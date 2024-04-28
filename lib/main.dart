import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_management_system/view/navigation/navigation_view.dart';

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
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
      useMaterial3: true,
      fontFamily: 'Montserrat',
    );

    return MaterialApp(
      title: 'Store Management System',
      theme: themeData,
      home: const NavigationTabView(),
    );
  }
}
