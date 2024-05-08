import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/components/search_components.dart';
import 'package:store_management_system/models/color_model.dart';

// TODO: Search bar need to be update to function properly.

class PalletHistoryView extends StatefulWidget {
  const PalletHistoryView({super.key});

  @override
  State<PalletHistoryView> createState() => _PalletHistoryViewState();
}

class _PalletHistoryViewState extends State<PalletHistoryView> {
  final TextEditingController searchController = TextEditingController();

  List<dynamic> pallets = List.empty();
  List<dynamic> searchPallet = List.empty();

  bool searchMode = false;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle = Text(
      "Search Pallet History",
      style: TextStyle(
        color: AppColor().matteBlack,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );

    Widget searchBar = PalletSearch(
      padding: const EdgeInsets.only(left: NavigationToolbar.kMiddleSpacing),
      controller: searchController,
      onSearch: (value) {
        searchPallet = pallets
            .where((element) =>
                element[""].contains(value) || element[""].contains(value))
            .toList();

        setState(() {});
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: searchMode ? searchBar : appBarTitle,
        ),
        backgroundColor: AppColor().milkWhite,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: (!searchMode)
                ? IconButton(
                    onPressed: () => setState(() => searchMode = true),
                    icon: const Icon(
                      FluentIcons.search_24_filled,
                      size: 28,
                    ),
                  )
                : TextButton(
                    onPressed: () => setState(() => searchMode = false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColor().yaleBlue,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      backgroundColor: AppColor().milkWhite,
      body: const Center(
        child: Text('Search History View Page'),
      ),
    );
  }
}
