import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/utils/main_utils.dart';

class Constant {
  static List<String> palletLocations = ['Inbound', 'Outbound'];
  static List<String> palletTypes = ['Palletise', 'Loose'];

  // testing purpose
  static List<String> forkliftDriverTest = ['Driver A', 'Driver B', 'Driver C'];
  static List<String> custNameTest = [
    '7-ELEVEN MALAYSIA SDN BHD',
    'Apex Pharmacy Marketing S/B- collection',
    'ALPHA HOME APPLIANCES SDN BHD',
    'APEX PHARMACY MARKETING SDN BHD',
  ];

  static List<ItemTest> itemTest = [
    ItemTest(customerName: '7-ELEVEN MALAYSIA SDN BHD', qty: 15),
    ItemTest(customerName: 'Apex Pharmacy Marketing S/B- collection', qty: 25),
    ItemTest(customerName: 'ALPHA HOME APPLIANCES SDN BHD', qty: 35),
    ItemTest(customerName: 'APEX PHARMACY MARKETING SDN BHD', qty: 35),
  ];
  static List<String> jobAssignedListTest = ['PTN0001'];
  static List<String> confirmJobListTest = ['PTN0001'];
  static List<String> palletLoadListTest = ['PTN0001', 'PTN002'];
}

Widget customTextLabel(String text) => Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: Text(
        text,
        style: TextStyle(
          color: AppColor().matteBlack,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

Widget customTextErr(String text) => Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 5),
      child: Text(
        text,
        style: TextStyle(color: Colors.red.shade900, fontSize: 12),
      ),
    );

String formatedCustName(String custName) {
  String formatText = "\u2022 ${custName.replaceRange(20, null, "...")}";
  return formatText;
}

String formatDateString(String date) {
  try {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd, HH:mm:ss').format(parsedDate);
  } catch (e) {
    return 'Invalid Date';
  }
}

InputDecoration customTextFormFieldDeco(
  String hintText, {
  Function()? onPressed,
}) =>
    InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade600, width: 1.7),
        borderRadius: BorderRadius.circular(10.0),
      ),
      suffixIcon: onPressed != null
          ? Align(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child: IconButton(
                onPressed: onPressed,
                icon: const Icon(FluentIcons.barcode_scanner_24_filled),
              ),
            )
          : null,
    );

Future showQuickItemInfo(
  BuildContext context,
  List<ItemTest>? activityDetailItem,
) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, a1, a2, widget) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: AlertDialog(
            backgroundColor: AppColor().milkWhite,
            shadowColor: Colors.black,
            elevation: 3.0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            title: const Center(
              child: Text(
                "Pallet Items",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                Container(
                  height: 210,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: activityDetailItem!.isEmpty
                        ? const Center(
                            child: Text("\u2022 No Pallet Items Available"),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 10),
                            shrinkWrap: true,
                            itemCount: activityDetailItem.length,
                            itemBuilder: ((context, index) => Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatedCustName(
                                              activityDetailItem[index]
                                                  .customerName),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "[Qty:${activityDetailItem[index].qty}]",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                )),
                          ),
                  ),
                ),
              ],
            ),
            actionsPadding: const EdgeInsets.all(8),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor().yaleBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future showQuickPICInfo(BuildContext context, Pallet pallet) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    pageBuilder: (context, animation1, animation2) {
      return AlertDialog(
        backgroundColor: AppColor().milkWhite,
        elevation: 3.0,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        title: const Center(
          child: Text(
            "Person In Charge",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          width: double.maxFinite,
          height: 330,
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Open By:'),
                    pallet.openByUserName.isEmpty
                        ? customEmptyValue
                        : Text(pallet.openByUserName),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Open On:'),
                    pallet.openPalletDateTime.isEmpty
                        ? customEmptyValue
                        : Text(formatDateString(pallet.openPalletDateTime)),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Move By:'),
                    pallet.moveByUserName.isEmpty
                        ? customEmptyValue
                        : Text(pallet.moveByUserName),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Move On:'),
                    pallet.movePalletDateTime.isEmpty
                        ? customEmptyValue
                        : Text(formatDateString(pallet.movePalletDateTime)),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Assign By:'),
                    pallet.assignByUserName.isEmpty
                        ? customEmptyValue
                        : Text(pallet.assignByUserName),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Assign On:'),
                    pallet.assignPalletDateTime.isEmpty
                        ? customEmptyValue
                        : Text(formatDateString(pallet.assignPalletDateTime)),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Load By:'),
                    pallet.loadByUserName.isEmpty
                        ? customEmptyValue
                        : Text(pallet.loadByUserName),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Load On:'),
                    pallet.loadPalletDateTime.isEmpty
                        ? customEmptyValue
                        : Text(pallet.loadPalletDateTime),
                  ],
                ),
                Divider(color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('Received & Signed by: '),
                const Text(''),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        actionsPadding: const EdgeInsets.all(8),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor().yaleBlue,
              ),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, a1, a2, widget) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: widget,
        ),
      );
    },
  );
}

Widget createPalletDetails(String detail, String? value, {int flex = 2}) {
  return Row(children: [
    Expanded(
      flex: 1,
      child: Text(
        detail,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    const Text(": ", style: TextStyle(fontSize: 15)),
    Expanded(
      flex: flex,
      child: (value == null)
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          : Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColor().tealBlue,
              ),
            ),
    ),
  ]);
}

// No need for current version
// Widget imgSliderContent() {
//   return Container(
//     child: CarouselSlider(
//         items: [1, 2, 3].map((e) {
//           return Container(
//             width: MediaQuery.of(context).size.width,
//             decoration: const BoxDecoration(
//               color: Color.fromRGBO(102, 153, 204, 1),
//             ),
//             child: Center(
//               child: Text('Image $e'),
//             ),
//           );
//         }).toList(),
//         options: CarouselOptions(
//           autoPlay: true,
//           autoPlayInterval: const Duration(seconds: 4),
//           height: 200,
//         )),
//   );
// }
