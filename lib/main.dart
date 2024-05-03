import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_management_system/firebase_options.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/utils/storage_utils.dart';
import 'package:store_management_system/view/login/login_view.dart';

Future<void> firebaseSetup() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (Platform.isIOS) {
    Storage.set(fcmToken: await FirebaseMessaging.instance.getAPNSToken());
  } else {
    Storage.set(fcmToken: await FirebaseMessaging.instance.getToken());
  }

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
    await Storage.set(fcmToken: fcmToken);
  }).onError((err) {
    debugPrint("[FirebaseMessaging] Error: ${err.toString()}");
  });

  await FirebaseMessaging.instance.requestPermission();
  // Handle notification message when on background
  // FirebaseMessaging.onBackgroundMessage(_handleMessage);
}

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(
    const RootApp(),
  );
}

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
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
