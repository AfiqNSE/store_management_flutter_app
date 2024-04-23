import 'package:flutter/material.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet_list_view/components.dart';
import 'package:store_management_system/view/pallet_list_view/pallet_details.dart';

class PalletListView extends StatefulWidget {
  const PalletListView({super.key});

  @override
  State<PalletListView> createState() => _PalletListViewState();
}

class _PalletListViewState extends State<PalletListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 254, 253, 1),
      body: Column(
        children: [
          Expanded(child: Builder(builder: (context) {
            return ListView.builder(
              itemCount: 6,
              itemBuilder: ((context, index) => createCard(index)),
            );
          }))
        ],
      ),
    );
  }

  Widget createCard(index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
        elevation: 3.0,
        color: index == 0 || index == 1
            ? Colors.amber.shade300
            : Colors.grey.shade400,
        shadowColor: Colors.black,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                SlideRoute(page: const PalletDetailsView(), toRight: true));
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: 100,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('PTN00$index'),
                      IconButton(
                        onPressed: () async {
                          await palletPICInfo(
                              context,
                              "John Doe",
                              "2024-04-22, 3:00 p.m",
                              "Jane Smith",
                              "2024-04-23, 3:00 p.m",
                              "Alice Johnson",
                              "2024-04-24, 3:00 p.m",
                              "Bob Brown",
                              "2024-04-25, 3:00 p.m",
                              "Ali Bin Abu");
                        },
                        icon: const Icon(
                          Icons.info_outline,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('DBA123$index'),
                      index == 0 || index == 1
                          ? const Text('OutBound')
                          : const Text('Inbound'),
                    ],
                  ),
                  index == 0
                      ? const Text('Load Job Confirm')
                      : const SizedBox.shrink(),
                  index == 1
                      ? const Text('Load Job Pending')
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
