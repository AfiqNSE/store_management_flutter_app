import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet/components.dart';

class PalletDetailsView extends StatefulWidget {
  const PalletDetailsView({super.key});

  @override
  State<PalletDetailsView> createState() => _PalletDetailsViewState();
}

class _PalletDetailsViewState extends State<PalletDetailsView> {
  late int total;
  String? _selectedDriver;

  final List<Item> _items = [
    Item('Toshiba', 10),
    Item('Sharp', 10),
    Item('Daikin', 10),
    Item('Delfi', 10),
  ];

  final List<String> driver = [
    'Driver A',
    'Driver B',
    'Driver C',
  ];

  @override
  void initState() {
    super.initState();
    total = _calculateTotal();
  }

  int _calculateTotal() {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar("Pallet Details"),
      backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topCenter,
                height: 520,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(237, 237, 237, 1),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Pallet No:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
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
                            fontWeight: FontWeight.w600,
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
                            await showPalletPICInfo(
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
                            );
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
                          fontWeight: FontWeight.w600,
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
            ],
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
          DataColumn(
              label: Text(
            'Name',
            style: TextStyle(
              color: Color.fromRGBO(40, 40, 43, 1),
            ),
          )),
          DataColumn(
              label: Text(
            'Quantity',
            style: TextStyle(
              color: Color.fromRGBO(40, 40, 43, 1),
            ),
          )),
          DataColumn(
              label: Text(
            'Actions',
            style: TextStyle(
              color: Color.fromRGBO(40, 40, 43, 1),
            ),
          )),
        ],
        rows: [
          ..._items
              .map((item) => DataRow(cells: [
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: Color.fromRGBO(40, 40, 43, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.quantity.toString(),
                            style: const TextStyle(
                              color: Color.fromRGBO(40, 40, 43, 1),
                            ),
                          ),
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
                Text(
                  'Total',
                  style: TextStyle(
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ],
            )), // Empty cell
            DataCell(Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  total.toString(),
                  style: const TextStyle(
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ],
            )),
            const DataCell(SizedBox.shrink()), // Empty cell
          ]),
        ],
      ),
    );
  }

  Widget _displayButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(160, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(31, 48, 94, 1),
                ),
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
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(160, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(31, 48, 94, 1),
                ),
                elevation: MaterialStateProperty.all(3),
              ),
              onPressed: () => _assignJob(),
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
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(31, 48, 94, 1),
                ),
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
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                minimumSize: MaterialStateProperty.all(const Size(160, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(31, 48, 94, 1),
                ),
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

  void _assignJob() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, a1, a2, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: AlertDialog(
                backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
                elevation: 3.0,
                title: const Center(
                  child: Text(
                    "Assign Job",
                    style: TextStyle(
                      color: Color.fromRGBO(40, 40, 43, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: double.maxFinite,
                      height: 210,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  'Forklift Driver: ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(40, 40, 43, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: forklifDriverDropDown(),
                            ),
                            const Row(
                              children: [
                                Text(
                                  'Lorry No. : ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(40, 40, 43, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                              child: Container(
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(252, 252, 252, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: TextField(
                                  cursorHeight: 22,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(40, 40, 43, 1),
                                  ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Lorry Number',
                                    hintStyle: const TextStyle(fontSize: 14),
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(10, 12, 0, 0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                actionsPadding: const EdgeInsets.only(top: 8, bottom: 5),
                actions: [
                  ListTile(
                    title: const Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(
                    thickness: 2.0,
                    indent: 20.0,
                    endIndent: 20.0,
                    height: 0.1,
                    color: Colors.grey.shade300,
                  ),
                  ListTile(
                    title: const Text(
                      "Cancel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          );
        },
      );

  Widget forklifDriverDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Text(
              'Select Forklift Driver',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        items: driver
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(40, 40, 43, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ))
            .toList(),
        value: _selectedDriver,
        onChanged: (String? driver) {
          setState(() {
            _selectedDriver = driver;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 35,
          width: 180,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(252, 252, 252, 1),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 180,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(252, 252, 252, 1),
            borderRadius: BorderRadius.circular(14),
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
