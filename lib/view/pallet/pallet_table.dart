import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';

class ActivityDetailsTableView extends StatefulWidget {
  final int palletActivityId;
  final List<PalletActivityDetail>? activityItems;
  const ActivityDetailsTableView(
      {super.key, this.activityItems, required this.palletActivityId});

  @override
  State<ActivityDetailsTableView> createState() => _ActivityDetailsTableState();
}

// TODO: Amend validation for signature checking
// TODO: Amend add, update api
class _ActivityDetailsTableState extends State<ActivityDetailsTableView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController custNameController = TextEditingController();
  TextEditingController itemQuantityController = TextEditingController();

  List<PalletActivityDetail> activityDetailItem = List.empty(growable: true);
  List<String> autoCompleteCustName = List.empty(growable: true);

  //testing purpose
  late int total;

  @override
  void initState() {
    super.initState();
    activityDetailItem.addAll(widget.activityItems!);
    total = _calculateTotal();
    _getCustomerName();
  }

  int _calculateTotal() {
    setState(() {});
    return activityDetailItem.fold(0, (sum, item) => sum + item.qty);
  }

  _getCustomerName() async {
    List<dynamic> res = await ApiServices.other.customers();
    for (var i = 0; i < res.length; i++) {
      autoCompleteCustName.add(res[i].customerName);
    }
  }

  _addItem(
    int customerId,
    String customerName,
    int qty,
    int palletActivityId,
  ) async {
    var res = await ApiServices.pallet.addItem(
      customerId,
      customerName,
      qty,
      palletActivityId,
    );
    if (mounted) {
      if (res != true) {
        customShowToast(
          context,
          'Failed To Add Item, Please Try Again.',
          Colors.red.shade300,
        );
        return;
      }
      customShowToast(
        context,
        'Successfully Add Item.',
        Colors.green.shade300,
      );
    }
    setState(() {
      _calculateTotal();
    });
  }

  _updateItem(
    int customerId,
    String customerName,
    int qty,
    int palletActivityId,
    int palletActivityDetailId,
  ) async {
    var res = await ApiServices.pallet.updateItem(
      customerId,
      customerName,
      qty,
      palletActivityId,
      palletActivityDetailId,
    );
    if (mounted) {
      if (res != true) {
        customShowToast(context, 'Failed To Update Item, Please Try Again.',
            Colors.red.shade300);
        return;
      }
      customShowToast(
        context,
        'Item Update Successful.',
        Colors.green.shade300,
      );
      return;
    }
    setState(() {
      _calculateTotal();
    });
  }

  _deleteItem(
    int palletActivityDetailId,
    int palletActivityId,
  ) async {
    var res = await ApiServices.pallet.deleteItem(
      palletActivityDetailId,
      palletActivityId,
    );
    if (mounted) {
      if (res != true) {
        customShowToast(
          context,
          'Failed To Delete Item, Please Try Again.',
          Colors.red.shade300,
        );
        return;
      }
      customShowToast(
        context,
        ' Item Deleted Successful.',
        Colors.green.shade300,
      );
      setState(() {
        _calculateTotal();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Create list area to show item list
    Widget activityDetail = Container(
      width: double.infinity,
      child: activityDetailItem.isEmpty
          ? const Center(
              child: Text('No item for this pallet.'),
            )
          : ListView.builder(
              itemCount: activityDetailItem.length,
              itemBuilder: (context, int index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => updateItem(index),
                        backgroundColor: Colors.blue.shade300,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                      SlidableAction(
                        onPressed: (_) => deleteItem(index),
                        backgroundColor: Colors.red.shade300,
                        foregroundColor: Colors.white,
                        icon: Icons.delete_forever,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 0.4,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                            child: Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  softWrap: true,
                                  "\u2022 ${activityDetailItem[index].customerName.toUpperCase()}",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade400,
                                width: 0.4,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  softWrap: true,
                                  "${activityDetailItem[index].qty.toString()}x",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );

    AppBar customAppBar = AppBar(
      title: const Text(
        'Item List',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColor().milkWhite,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            decoration: BoxDecoration(
                color: AppColor().blueZodiac,
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: () => addItem(widget.palletActivityId),
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );

    Widget customBottomBar = BottomAppBar(
      elevation: 5,
      height: 60,
      color: AppColor().blueZodiac,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Items:',
              style: TextStyle(
                color: AppColor().milkWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              "${total.toString()} Items",
              style: TextStyle(
                color: AppColor().milkWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: customAppBar,
      backgroundColor: AppColor().milkWhite,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 5, 10),
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: Text(
                      'Customer Name',
                      style: TextStyle(
                        color: AppColor().yaleBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Quantity',
                      style: TextStyle(
                        color: AppColor().yaleBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
          Divider(
            color: AppColor().blueZodiac,
            thickness: 2.0,
          ),
          Expanded(child: activityDetail),
        ],
      ),
      bottomNavigationBar: customBottomBar,
    );
  }

  updateItem(index) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.white,
            elevation: 3.0,
            title: const Center(
              child: Text(
                'Fill the item form',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: custNameController,
                    cursorHeight: 22,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                    decoration: customTextFormFieldDeco(
                        activityDetailItem[index].customerName),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: itemQuantityController,
                    cursorHeight: 22,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                    decoration: customTextFormFieldDeco(
                        activityDetailItem[index].qty.toString()),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColor().blueZodiac,
                ),
                onPressed: () => _updateItem(
                  activityDetailItem[index].customerId,
                  custNameController.text,
                  int.parse(itemQuantityController.text),
                  widget.palletActivityId,
                  activityDetailItem[index].palletActivityDetailId,
                ),
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
                    side: BorderSide(
                      color: Colors.blue.shade600,
                      width: 0.8,
                    ),
                  ),
                  backgroundColor: AppColor().milkWhite,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  reset();
                },
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
          );
        },
      );

  addItem(palletActivityId) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.white,
            elevation: 3.0,
            title: const Center(
              child: Text(
                'Fill the item form',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RawAutocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        } else {
                          return autoCompleteCustName.where((String custName) =>
                              custName.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase()));
                        }
                      },
                      onSelected: (String selected) {
                        setState(() {
                          custNameController.text = selected;
                        });
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            child: SizedBox(
                              width: 245,
                              height: 200,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: options.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final String option =
                                      options.elementAt(index);
                                  return ListTile(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Colors.grey.shade100,
                                        width: 1,
                                      ),
                                    ),
                                    title: Text(option),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      fieldViewBuilder: (context, textEditingController,
                          focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: textEditingController,
                          cursorHeight: 22,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                          decoration:
                              customTextFormFieldDeco('Enter Customer Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter customer name';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          focusNode: focusNode,
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: itemQuantityController,
                      cursorHeight: 22,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                      decoration: customTextFormFieldDeco('Enter Quantity'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColor().blueZodiac,
                ),
                onPressed: () => _validateAddItem(palletActivityId),
                child: Text(
                  "Save Items",
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
                    side: BorderSide(
                      color: Colors.blue.shade600,
                      width: 0.8,
                    ),
                  ),
                  backgroundColor: AppColor().milkWhite,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  reset();
                },
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
          );
        },
      );

  // Check either the item already in the table or not
  _validateAddItem(palletActivityId) async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      int custId = -1;

      for (var i = 0; i < activityDetailItem.length; i++) {
        if (activityDetailItem[i].customerName == custNameController.text) {
          custId = activityDetailItem[i].customerId;
          return;
        }
      }

      var contain =
          activityDetailItem.where((element) => element.customerId == custId);

      if (contain.isEmpty) {
        await _addItem(
          custId,
          custNameController.text,
          int.parse(itemQuantityController.text),
          palletActivityId,
        );
      } else {
        customShowToast(
          context,
          "The item already in the table",
          Colors.red.shade300,
        );
      }
      reset();
      setState(() {});
    }
  }

  deleteItem(index) => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.white,
            elevation: 3.0,
            title: const Center(
              child: Text(
                'Confirm to delete this item?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => _deleteItem(
                  widget.palletActivityId,
                  activityDetailItem[index].palletActivityDetailId,
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColor().yaleBlue,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColor().yaleBlue,
                  ),
                ),
              ),
            ],
          );
        },
      );

  void reset() {
    custNameController.clear();
    itemQuantityController.clear();
  }
}
