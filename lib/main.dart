import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/firebase_options.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/notif.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/models/summary.dart';
import 'package:store_management_system/utils/db_utils.dart';
import 'package:store_management_system/utils/storage_utils.dart';
import 'package:store_management_system/view/login/login_view.dart';

// TODO: setup notification for ios

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance.initialize();
  await firebaseSetup();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SummaryNotifier()),
      ChangeNotifierProvider(create: (context) => NotifNotifier()),
      ChangeNotifierProvider(create: (context) => PalletNotifier()),
    ],
    child: const RootApp(),
  ));
}

Future<void> firebaseSetup() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (Platform.isIOS) {
    Storage.instance.setFcmToken(await messaging.getAPNSToken() ?? "");
  } else {
    Storage.instance.setFcmToken(await messaging.getToken() ?? "");

    // Set notification channel
    const AndroidNotificationChannel defaultChannel =
        AndroidNotificationChannel(
      'default_channel', // id
      'Default Importance Notifications',
      description: 'This channel is used for fcm notifications.',
    );

    // Set notification channel
    const AndroidNotificationChannel highChannel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    var notifPlugin = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await notifPlugin?.createNotificationChannel(defaultChannel);
    await notifPlugin?.createNotificationChannel(highChannel);
  }

  FirebaseMessaging.instance.onTokenRefresh
      .listen(Storage.instance.setFcmToken)
      .onError((err) {
    debugPrint("[FirebaseMessaging] Error: ${err.toString()}");
  });

  // Subscribe to topic on each app start-up
  await messaging.subscribeToTopic('sma-broadcast');

  // Handle notification message when on background
  FirebaseMessaging.onBackgroundMessage(_handleMessage);
}

Future<void> _handleMessage(RemoteMessage message) async {
  if (message.notification != null) {
    await DB.instance.insertNotif(Notif(
      messageId: message.messageId ?? "",
      guid: message.data["guid"],
      code: message.data["code"] == null ? 0 : int.parse(message.data["code"]),
      activityId:
          message.data["id"] == null ? 0 : int.parse(message.data["id"]),
      palletNo: message.data["palletNo"],
      createdOn: DateTime.now(),
    ));
  }
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    super.initState();
    // Handle notification message when on foreground
    FirebaseMessaging.onMessage.listen(_addMessage);
  }

  _addMessage(RemoteMessage message) {
    int code =
        message.data["code"] == null ? 0 : int.parse(message.data["code"]);
    int activityId =
        message.data["id"] == null ? 0 : int.parse(message.data["id"]);

    switch (code) {
      case 1:
        // Update summary values
        Provider.of<SummaryNotifier>(context, listen: false).update();
        break;
      case 2:
        // Update summary values
        Provider.of<SummaryNotifier>(context, listen: false).update();
        // Update pallet info
        Provider.of<PalletNotifier>(context, listen: false).update(activityId);
        break;
      case 3:
        // Update pallet info
        Provider.of<PalletNotifier>(context, listen: false).update(activityId);
        break;
      default:
    }

    if (message.notification != null) {
      // Add notif to database
      Provider.of<NotifNotifier>(context, listen: false).add(Notif(
        messageId: message.messageId ?? "",
        guid: message.data["guid"] ?? "",
        code: code,
        activityId: activityId,
        palletNo: message.data["palletNo"] ?? "",
        createdOn: DateTime.now(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var baseTheme = ThemeData(brightness: Brightness.dark);
    ThemeData themeData = ThemeData(
      primarySwatch: Colors.blue,
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme).apply(
        bodyColor: AppColor().matteBlack,
        displayColor: AppColor().matteBlack,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Store Management Application',
      theme: themeData,
      home: const LoginView(),
    );
  }
}
