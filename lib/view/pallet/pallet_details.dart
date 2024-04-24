import 'package:flutter/material.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet/components.dart';

class Item {
  final String name;
  final int quantity;
  Item(this.name, this.quantity);
}

class PalletDetailsView extends StatefulWidget {
  const PalletDetailsView({super.key});

  @override
  State<PalletDetailsView> createState() => _PalletDetailsViewState();
}

class _PalletDetailsViewState extends State<PalletDetailsView> {
  final List<Item> _items = [
    Item('Toshiba', 10),
    Item('Sharp', 10),
    Item('Daikin', 10),
    Item('Delfi', 10),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Pallet Details"),
      backgroundColor: const Color.fromRGBO(245, 254, 253, 1),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'Pallet No:',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'PTN0001',
                  style: TextStyle(
                    fontSize: 40,
                    color: Color.fromRGBO(0, 102, 178, 1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Divider(
                  color: Colors.grey.shade400,
                  indent: 8,
                  endIndent: 8,
                ),
                Row(
                  children: [
                    const Text(
                      'Status: ',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Text(
                      'In Process',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 102, 178, 1),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
                        color: Color.fromRGBO(0, 102, 178, 1),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                _palletInfo,
                const SizedBox(height: 20),
                ExpansionTile(
                  collapsedBackgroundColor:
                      const Color.fromRGBO(168, 199, 230, 1),
                  title: const Text(
                    'Pallet Items:',
                    style: TextStyle(
                      color: Color.fromRGBO(40, 40, 43, 1),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  children: [
                    _palletItems(),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                _displayButton(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Widget _palletInfo = Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      createPalletDetails('Type', 'Palletise'),
      const SizedBox(height: 5),
      createPalletDetails('Destination', 'Kuantan'),
      const SizedBox(height: 5),
      createPalletDetails('Lorry No', 'ABC 1234'),
      const SizedBox(height: 5),
      createPalletDetails('Forklift Driver', 'Ali Bin Abu'),
      const SizedBox(height: 5),
    ],
  );

  Widget _palletItems() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        border: TableBorder.all(width: 0.5),
        columnSpacing: 35,
        headingTextStyle: const TextStyle(fontWeight: FontWeight.w600),
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Quantity')),
          DataColumn(label: Text('Actions')),
        ],
        rows: [
          ..._items
              .map((item) => DataRow(cells: [
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.name),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item.quantity.toString()),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ]))
              .toList(),
          // Row for Total Quantity
          DataRow(cells: [
            const DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total'),
              ],
            )), // Empty cell
            DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_calculateTotal().toString()),
              ],
            )),
            const DataCell(SizedBox.shrink()), // Empty cell
          ]),
        ],
      ),
    );
  }

  int _calculateTotal() {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  Widget _displayButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(102, 153, 204, 1)),
                elevation: MaterialStateProperty.all(3),
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.compare_arrows_sharp,
                color: Colors.white,
              ),
              label: const Text(
                'Move',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(102, 153, 204, 1)),
                elevation: MaterialStateProperty.all(3),
              ),
              onPressed: () async {
                await assignJob();
              },
              icon: const Icon(
                Icons.compare_arrows_sharp,
                color: Colors.white,
              ),
              label: const Text(
                'Assign',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(102, 153, 204, 1)),
                elevation: MaterialStateProperty.all(3),
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.mode_edit_outline_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'Signature',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(102, 153, 204, 1)),
                elevation: MaterialStateProperty.all(3),
              ),
              onPressed: () {},
              icon: const Icon(
                Icons.print_outlined,
                color: Colors.white,
              ),
              label: const Text(
                'Print',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  assignJob() => showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, a1, a2, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: const AlertDialog(
                backgroundColor: Color.fromRGBO(245, 254, 253, 1),
                elevation: 3.3,
                title: Text(
                  "Assign Job",
                ),
              ),
            ),
          );
        },
      );
}
