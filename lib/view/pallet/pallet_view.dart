import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';

class PalletView extends StatefulWidget {
  const PalletView({super.key});

  @override
  State<PalletView> createState() => _PalletViewState();
}

class _PalletViewState extends State<PalletView> with TickerProviderStateMixin {
  late TabController _tabController;
  late int total;

  final List<Item> _items = [
    Item('Toshiba', 10),
    Item('Sharp', 10),
    Item('Daikin', 10),
    Item('Delfi', 10),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    total = _calculateTotal();
  }

  int _calculateTotal() {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
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
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              "Today's Pallet List",
              style: TextStyle(
                color: Color.fromRGBO(40, 40, 43, 1),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 25.0),
              child: Icon(
                FluentIcons.search_24_filled,
                size: 28,
                color: Color.fromRGBO(40, 40, 43, 1),
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text(
                  'All',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'InBound',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'OutBound',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color.fromRGBO(40, 40, 43, 1),
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
              color: const Color.fromRGBO(252, 252, 252, 1),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: ((context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: createPalletCard(index),
                      )),
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(252, 252, 252, 1),
              child: const Center(
                child: Text(
                  "InBound Pallets",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(252, 252, 252, 1),
              child: const Center(
                child: Text(
                  "OutBound Pallets",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Create a card for each pallet in the list
  Widget createPalletCard(index) {
    return Card(
      elevation: 5,
      color: index == 0 || index == 1
          ? const Color.fromRGBO(249, 205, 82, 1)
          : const Color.fromRGBO(211, 211, 211, 1),
      shadowColor: Colors.black,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PalletDetailsView()));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10, 0),
          child: SizedBox(
            height: 125,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PTN00$index',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                          color: Color.fromRGBO(40, 40, 43, 1),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await showPalletItemsInfo(context, _items);
                            },
                            child: const Icon(
                              FluentIcons.clipboard_task_list_ltr_24_filled,
                              size: 30,
                              color: Color.fromRGBO(40, 40, 43, 1),
                            ),
                          ),
                          const SizedBox(width: 18),
                          GestureDetector(
                            onTap: () => showPalletPICInfo(
                              context,
                              "John Doe",
                              "2024-04-22, 3:00 p.m",
                              "Jane Smith",
                              "2024-04-23, 3:00 p.m",
                              "Alice Johnson",
                              "2024-04-24, 3:00 p.m",
                              "Bob Brown",
                              "2024-04-25, 3:00 p.m",
                              "Ali Bin Abu",
                            ),
                            child: const Icon(
                              FluentIcons.person_clock_24_filled,
                              size: 30,
                              color: Color.fromRGBO(40, 40, 43, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DBA123$index',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Color.fromRGBO(40, 40, 43, 1),
                        ),
                      ),
                      index == 0 || index == 1
                          ? const Text(
                              'OutBound',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color.fromRGBO(40, 40, 43, 1),
                              ),
                            )
                          : const Text(
                              'InBound',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color.fromRGBO(40, 40, 43, 1),
                              ),
                            ),
                    ],
                  ),
                  index == 0
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kuantan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Color.fromRGBO(40, 40, 43, 1),
                              ),
                            ),
                            Text(
                              'Load Job Confirm',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color.fromRGBO(40, 40, 43, 1),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  index == 1
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kuantan',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Color.fromRGBO(40, 40, 43, 1),
                              ),
                            ),
                            Text(
                              'Load Job Pending',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Color.fromRGBO(40, 40, 43, 1),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
