import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/components/search_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/models/summary.dart';

class PalletView extends StatefulWidget {
  const PalletView({super.key});

  @override
  State<PalletView> createState() => _PalletViewState();
}

class _PalletViewState extends State<PalletView> with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();

  Pallet? pallet;
  late TabController _tabController;
  late int total;

  bool searchMode = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Provider.of<PalletNotifier>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle = const Text(
      "Today's Pallet List",
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    );

    Widget search = PalletSearch(
      padding: const EdgeInsets.only(left: NavigationToolbar.kMiddleSpacing),
      controller: searchController,
      onSearch: (value) {
        setState(() {});
      },
    );

    Widget createTab(text, value) => Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(width: 5),
              value != 0
                  ? Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.shade300,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );

    // Create Tab categories; All, InBound, OutBound
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: searchMode ? search : appBarTitle,
          ),
          backgroundColor: AppColor().milkWhite,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: (!searchMode)
                  ? IconButton(
                      onPressed: () => setState(() => searchMode = true),
                      icon: const Icon(FluentIcons.search_24_filled, size: 28),
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
          bottom: searchMode
              ? null
              : TabBar(
                  labelColor: AppColor().blueZodiac,
                  indicatorColor: AppColor().blueZodiac,
                  controller: _tabController,
                  tabs: <Widget>[
                    if (searchMode == true) ...{
                      const Text('Pallet List'),
                    } else ...{
                      Consumer<SummaryNotifier>(
                          builder: (context, value, child) {
                        return createTab('All', value.pallets);
                      }),
                      Consumer<SummaryNotifier>(
                          builder: (context, value, child) {
                        return createTab('InBound', value.inBound);
                      }),
                      Consumer<SummaryNotifier>(
                          builder: (context, value, child) {
                        return createTab('OutBound', value.outBound);
                      })
                    }
                  ],
                ),
        ),
        body: searchMode
            ? const Center(
                child: Text('Search'),
              )
            : Consumer<PalletNotifier>(
                builder: (context, value, child) {
                  List<Pallet> allPalletList =
                      value.pallets.entries.map((e) => e.value).toList();

                  if (allPalletList.isNotEmpty) {
                    isLoading = true;
                  }

                  List<Pallet> inBoundPalletList = List.empty(growable: true);
                  List<Pallet> outBoundPalletList = List.empty(growable: true);

                  for (var i = 0; i < allPalletList.length; i++) {
                    if (allPalletList[i].palletLocation == "inbound") {
                      inBoundPalletList.add(allPalletList[i]);
                    }
                    if (allPalletList[i].palletLocation == "outbound") {
                      outBoundPalletList.add(allPalletList[i]);
                    }
                  }

                  if (isLoading == true) {
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: AppColor().blueZodiac,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Loading data...'),
                      ],
                    );
                  }

                  return TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(
                        color: AppColor().milkWhite,
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: allPalletList.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/no-pallet-background.png',
                                    scale: 2.3,
                                  ),
                                  const SizedBox(height: 5),
                                  const Text('No pallet for today.'),
                                ],
                              ))
                            : ListView.builder(
                                itemCount: allPalletList.length,
                                itemBuilder: ((context, index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: createPalletCard(
                                          context, allPalletList[index]),
                                    )),
                              ),
                      ),
                      Container(
                        color: AppColor().milkWhite,
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: inBoundPalletList.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/no-inbound-background.png',
                                    scale: 1.8,
                                  ),
                                  const SizedBox(height: 3),
                                  const Text('No inbound pallet for today.'),
                                ],
                              ))
                            : ListView.builder(
                                itemCount: inBoundPalletList.length,
                                itemBuilder: ((context, index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: createPalletCard(
                                          context, inBoundPalletList[index]),
                                    )),
                              ),
                      ),
                      Container(
                        color: AppColor().milkWhite,
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: outBoundPalletList.isEmpty
                            ? Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/no-outbound-background.png',
                                    scale: 1.8,
                                  ),
                                  const SizedBox(height: 3),
                                  const Text('No outbound pallet for today.'),
                                ],
                              ))
                            : ListView.builder(
                                itemCount: outBoundPalletList.length,
                                itemBuilder: ((context, index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: createPalletCard(
                                          context, outBoundPalletList[index]),
                                    )),
                              ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
