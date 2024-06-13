import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';

class Constant {
  static List<String> palletLocations = ['Inbound', 'Outbound'];
  static List<String> palletTypes = ['Palletise', 'Loose'];
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

Widget createPalletCard(
  BuildContext context,
  Pallet pallet, {
  bool searchView = false,
}) {
  return Card(
    elevation: 5,
    color: searchView
        ? customCardColorStatus(pallet.status)
        : customCardColor(pallet.palletLocation),
    shadowColor: Colors.black,
    child: InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              PalletDetailsView(palletActivityId: pallet.palletActivityId),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.3, color: Colors.grey.shade600),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        height: 135,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                pallet.palletType.capitalizeOnly(),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              (pallet.lorryNo != "")
                  ? Text(
                      pallet.lorryNo.capitalizeOnly(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    )
                  : const Text(
                      "No Lorry Assign",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                pallet.destination.capitalizeOnly(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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

Future showQuickItemInfo(
  BuildContext context,
  List<PalletActivityDetail> itemList,
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
                    child: itemList.isEmpty
                        ? const Center(
                            child: Text("No Pallet Items Available"),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(bottom: 10),
                            itemCount: itemList.length,
                            itemBuilder: ((context, index) => Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            "\u2022 ${itemList[index].customerName}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "[Qty:${itemList[index].qty}]",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
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

Future showQuickPICInfo(
  BuildContext context,
  Pallet pallet,
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
            elevation: 3.0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            title: const Center(
              child: Text(
                "Person In Charge",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Open By:'),
                          pallet.openByUserName!.isEmpty
                              ? customEmptyValue
                              : Text(pallet.openByUserName!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Open On:'),
                          pallet.openPalletDateTime!.isEmpty
                              ? customEmptyValue
                              : Text(
                                  formatDateString(pallet.openPalletDateTime!)),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Move By:'),
                          pallet.moveByUserName!.isEmpty
                              ? customEmptyValue
                              : Text(pallet.moveByUserName!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Move On:'),
                          pallet.movePalletDateTime!.isEmpty
                              ? customEmptyValue
                              : Text(
                                  formatDateString(pallet.movePalletDateTime!)),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Assign By:'),
                          pallet.assignByUserName!.isEmpty
                              ? customEmptyValue
                              : Text(pallet.assignByUserName!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Assign On:'),
                          pallet.assignPalletDateTime!.isEmpty
                              ? customEmptyValue
                              : Text(formatDateString(
                                  pallet.assignPalletDateTime!,
                                )),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Load By:'),
                          pallet.loadByUserName!.isEmpty
                              ? customEmptyValue
                              : Text(pallet.loadByUserName!),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Load On:'),
                          pallet.loadPalletDateTime!.isEmpty
                              ? customEmptyValue
                              : Text(formatDateString(
                                  pallet.loadPalletDateTime!,
                                )),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      const Text('Received & Signed by: '),
                      pallet.closeByUserName!.isEmpty
                          ? customEmptyValue
                          : Text(pallet.closeByUserName!),
                      const SizedBox(height: 5),
                    ],
                  ),
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
          ),
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
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
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
