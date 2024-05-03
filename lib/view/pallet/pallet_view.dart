import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/components/search_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/pallet_model.dart';

class PalletView extends StatefulWidget {
  const PalletView({super.key});

  @override
  State<PalletView> createState() => _PalletViewState();
}

class _PalletViewState extends State<PalletView> with TickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  List<dynamic> pallets = List.empty();
  List<dynamic> searchPallet = List.empty();

  List<Pallet> allPallet = List.empty(growable: true);
  List<Pallet> inBoundPallet = List.empty(growable: true);
  List<Pallet> outBoundPallet = List.empty(growable: true);

  Pallet? pallet;
  late TabController _tabController;
  late int total;

  bool searchMode = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().milkWhite,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: palletCategories(),
          ),
        ],
      ),
    );
  }

  // Create Tab categories; All, InBound, OutBound
  Widget palletCategories() {
    Widget appBarTitle = const Text(
      "Today's Pallet List",
      style: TextStyle(
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

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
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
          bottom: TabBar(
            labelColor: AppColor().blueZodiac,
            indicatorColor: AppColor().blueZodiac,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text(
                  'All',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'InBound',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'OutBound',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              color: AppColor().milkWhite,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: allPallet.isEmpty
                    ? const Center(
                        child: Text('No pallets for today'),
                      )
                    : ListView.builder(
                        itemCount: allPallet.length,
                        itemBuilder: ((context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: createPalletCard(
                                context,
                                allPallet[index],
                              ),
                            )),
                      ),
              ),
            ),
            Container(
              color: AppColor().milkWhite,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: inBoundPallet.isEmpty
                    ? const Center(
                        child: Text('No inBound pallet'),
                      )
                    : ListView.builder(
                        itemCount: inBoundPallet.length,
                        itemBuilder: ((context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: createPalletCard(
                                context,
                                inBoundPallet[index],
                              ),
                            )),
                      ),
              ),
            ),
            Container(
              color: AppColor().milkWhite,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: outBoundPallet.isEmpty
                    ? const Center(
                        child: Text('No outBound Pallet'),
                      )
                    : ListView.builder(
                        itemCount: outBoundPallet.length,
                        itemBuilder: ((context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: createPalletCard(
                                context,
                                outBoundPallet[index],
                              ),
                            )),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
