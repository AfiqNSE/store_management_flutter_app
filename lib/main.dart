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
import 'package:store_management_system/models/summary.dart';
import 'package:store_management_system/utils/storage_utils.dart';
import 'package:store_management_system/view/login/login_view.dart';

// TODO: setup notification for ios

void main() async {
  await firebaseSetup();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(ChangeNotifierProvider(
    create: (context) => SummaryNotifier(),
    child: const RootApp(),
  ));
}

Future<void> firebaseSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  await messaging.subscribeToTopic('broadcast');

  // Handle notification message when on background
  FirebaseMessaging.onBackgroundMessage(_handleMessage);
}

@pragma('vm:entry-point')
Future<void> _handleMessage(RemoteMessage message) async {
  debugPrint(message.toString());
  // RemoteNotification? notification = message.notification;
  // if (notification != null) {
  //   await DB.instance.insert(Notif(
  //     guid: message.data["guid"],
  //     messageId: message.messageId ?? "",
  //     title: notification.title ?? "",
  //     content: notification.body ?? "",
  //     referenceNo: message.data["ref"],
  //     createdOn: DateTime.now(),
  //   ));
  // }
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
    Map<String, dynamic> data = message.data;
    debugPrint(data.toString());

    // Update summary values
    Provider.of<SummaryNotifier>(context, listen: false).update();

    // Add notif to database
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
