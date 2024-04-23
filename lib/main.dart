import 'package:flutter/material.dart';
import 'package:store_management_system/view/navigation_view/navigation_view.dart';

void main() {
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
    // final textTheme = Theme.of(context).textTheme.apply(
    //       bodyColor: const Color.fromRGBO(0, 102, 178, 1),
    //       displayColor: const Color.fromRGBO(0, 102, 178, 1),
    //     );
    ThemeData themeData = ThemeData(
      primarySwatch: Colors.blue,
      // textTheme: textTheme,
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
