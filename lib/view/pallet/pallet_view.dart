import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/components/search_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/models/summary.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';

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

  late String _searchValue = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Provider.of<PalletNotifier>(context, listen: false).initialize();
  }

  // Only to search active pallet at Pallet View
  searchActivePallet(String palletNo) async {
    Map<String, dynamic> res = await ApiServices.pallet.getByNo(palletNo);

    if (mounted) {
      if (res.containsKey("err")) {
        customShowToast(context, "No Pallet Found", Colors.red.shade300);
        return;
      }

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PalletDetailsView(palletNo: palletNo)));
    }
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
      activePalletOnly: true,
      padding: const EdgeInsets.only(left: NavigationToolbar.kMiddleSpacing),
      controller: searchController,
      onSearch: (value) async {
        _searchValue = value;
        await searchActivePallet(_searchValue);
      },
    );

    Widget createTab(text, value) => Tab(
          child: Stack(
            children: [
              Center(
                child: Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              value != 0
                  ? Align(
                      alignment: Alignment.topRight,
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: AppColor().milkWhite,
                title: searchMode ? search : appBarTitle,
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: (!searchMode)
                        ? IconButton(
                            onPressed: () => setState(() => searchMode = true),
                            icon: const Icon(FluentIcons.search_24_filled,
                                size: 28),
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
                  tabs: <Widget>[
                    Consumer<SummaryNotifier>(builder: (context, value, child) {
                      return createTab('All', value.pallets);
                    }),
                    Consumer<SummaryNotifier>(builder: (context, value, child) {
                      return createTab('InBound', value.inBound);
                    }),
                    Consumer<SummaryNotifier>(builder: (context, value, child) {
                      return createTab('OutBound', value.outBound);
                    })
                  ],
                ),
              ),
            ];
          },
          body: Consumer<PalletNotifier>(
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
                Container(
                  color: const Color.fromRGBO(255, 255, 255, .8),
                  child:
                      const Center(child: CircularProgressIndicator.adaptive()),
                );
              }

              return MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    Container(
                      color: AppColor().milkWhite,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: allPalletList.isEmpty
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/pallet-background.png',
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
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: inBoundPalletList.isEmpty
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/inbound-background.png',
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
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: outBoundPalletList.isEmpty
                          ? Center(
                              child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/outbound-background.png',
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
