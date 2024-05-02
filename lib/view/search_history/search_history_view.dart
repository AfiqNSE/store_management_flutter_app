import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class PalletHistoryView extends StatefulWidget {
  const PalletHistoryView({super.key});

  @override
  State<PalletHistoryView> createState() => _PalletHistoryViewState();
}

class _PalletHistoryViewState extends State<PalletHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            "Search Pallet History",
            style: TextStyle(
              color: Color.fromRGBO(40, 40, 43, 1),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
      ),
      backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
      body: const Center(
        child: Text('Search History View Page'),
      ),
    );
  }
}
