import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/components/search_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/pallet_model.dart';
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

    Widget createPalletCard(Pallet pallet) {
      return Card(
        elevation: 5,
        color: customCardColor(pallet.palletLocation),
        shadowColor: Colors.black,
        child: InkWell(
          onTap: () => Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => PalletDetailsView(
                    palletActivityId: pallet.palletActivityId,
                  ),
                ),
              )
              .then((_) => setState(() {})),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: Colors.grey.shade600),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            height: 125,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pallet.palletNo,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),
                      ),
                      Row(children: [
                        GestureDetector(
                          onTap: () => showQuickItemInfo(context, pallet.items),
                          child: const Icon(
                            FluentIcons.clipboard_task_list_ltr_24_filled,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 18),
                        GestureDetector(
                          onTap: () => showQuickPICInfo(context, pallet),
                          child: const Icon(
                            FluentIcons.person_clock_24_filled,
                            size: 30,
                          ),
                        ),
                      ]),
                    ]),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pallet.lorryNo.capitalizeOnly(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        pallet.palletLocation.capitalizeOnly(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pallet.destination.capitalizeOnly(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        pallet.status,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      );
    }

    // Create Tab categories; All, InBound, OutBound
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
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
          bottom: TabBar(
            labelColor: AppColor().blueZodiac,
            indicatorColor: AppColor().blueZodiac,
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text(
                  'All',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              Tab(
                child: Text(
                  'InBound',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              Tab(
                child: Text(
                  'OutBound',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
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
                                  allPalletList[index],
                                ),
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
                                  inBoundPalletList[index],
                                ),
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
                                  outBoundPalletList[index],
                                ),
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
