import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';

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
        title: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Text(
            "Search Pallet History",
            style: TextStyle(
              color: AppColor().matteBlack,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: AppColor().milkWhite,
      ),
      backgroundColor: AppColor().milkWhite,
      body: const Center(
        child: Text('Search History View Page'),
      ),
    );
  }
}
