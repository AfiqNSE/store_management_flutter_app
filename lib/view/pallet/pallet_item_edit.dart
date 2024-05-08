import 'package:flutter/material.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/utils/main_utils.dart';

class ItemTableEditView extends StatefulWidget {
  final List<Item>? palletItems;
  const ItemTableEditView({super.key, this.palletItems});

  @override
  State<ItemTableEditView> createState() => _ItemTableEditViewState();
}

class _ItemTableEditViewState extends State<ItemTableEditView> {
  //testing purpose
  late int total;

  @override
  void initState() {
    super.initState();
    total = _calculateTotal();
  }

  int _calculateTotal() {
    return widget.palletItems!.fold(0, (sum, item) => sum + item.qty);
  }

  @override
  Widget build(BuildContext context) {
    // Create table for pallet items
    Widget palletItems = Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.maxFinite,
        child: DataTable(
          border: TableBorder.all(width: 0.5),
          headingTextStyle: const TextStyle(fontWeight: FontWeight.w600),
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Quantity')),
          ],
          rows: [
            ...widget.palletItems!
                .map((item) => DataRow(cells: [
                      DataCell(
                        Autocomplete<String>(
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return Constant.custName;
                            }
                            return Constant.custName.where(
                              (custName) => custName.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()),
                            );
                          },
                          onSelected: (suggestion) {
                            // handle user selection
                          },
                          initialValue:
                              TextEditingValue(text: item.customerName),
                        ),
                        showEditIcon: true,
                        onTap: () {},
                      ),
                      DataCell(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.qty.toString()),
                          ],
                        ),
                        showEditIcon: true,
                        onTap: () {},
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
                  Text(total.toString()),
                ],
              )),
            ]),
          ],
        ),
      ),
    );

    // Action buttons for save changes and cancel
    Widget actionButtons = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppColor().blueZodiac,
            ),
            onPressed: () {},
            child: Text(
              "Save Changes",
              style: TextStyle(
                color: AppColor().milkWhite,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  color: Color.fromRGBO(102, 153, 204, 1),
                  width: 1.3,
                ),
              ),
              backgroundColor: AppColor().milkWhite,
            ),
            onPressed: () {},
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: customAppBar('Edit Item Table'),
      backgroundColor: AppColor().milkWhite,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Create pallet items
              palletItems,
              // Create action buttons
              actionButtons,
            ],
          ),
        ),
      ),
    );
  }
}
