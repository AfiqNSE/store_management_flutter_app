import 'dart:io';
import 'dart:ui' as ui;

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_management_system/components/pallet_assign_job_form.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/view/pallet/pallet_table.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

//TODO: Change snackbar to customToast

class PalletDetailsView extends StatefulWidget {
  final int palletActivityId;
  final String palletNo;

  /// Create a pallet details view, either palletActivityId or palletNo is required.
  /// If palletActivityId is given, palletNo will be ignored. Otherwise, it will search
  /// pallet with the palletNo.
  const PalletDetailsView({
    super.key,
    this.palletActivityId = 0,
    this.palletNo = "",
  });

  @override
  State<PalletDetailsView> createState() => _PalletDetailsViewState();
}

class _PalletDetailsViewState extends State<PalletDetailsView> {
  final GlobalKey<AssignJobFormState> assignKey = GlobalKey();
  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

  Pallet? pallet;
  int itemTotal = 0;

  List<dynamic> drivers = List.empty();

  bool _signature = false;
  bool expanded = false;

  bool loading = false;
  bool reqLoading = false;
  bool isAccess = true;

  @override
  void initState() {
    super.initState();
    loadPallet().then((value) {
      if (value != null && value > 0) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Pallet not found."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          )),
        );
      }
    });

    loadDrivers();
  }

  // Load pallet when pallectActivityId is not present
  loadPallet() async {
    if (widget.palletActivityId != 0) {
      return;
    }

    // Search pallet with palletNo
    Map<String, dynamic> res = await ApiServices.pallet.getByNo(
      widget.palletNo,
    );

    int err = 0;
    if (res.containsKey("err")) {
      pallet = Pallet.empty();
      err = 1;
    } else {
      pallet = Pallet.fromMap(res);
      itemTotal =
          pallet!.palletActivityDetail!.fold(0, (sum, item) => sum + item.qty);
    }

    setState(() {});
    return err;
  }

  loadDrivers() async {
    drivers = await ApiServices.user.getDrivers();
  }

  @override
  Widget build(BuildContext context) {
    // Get pallet from provider
    if (widget.palletActivityId != 0) {
      pallet =
          Provider.of<PalletNotifier>(context).pallets[widget.palletActivityId];
    }

    // Create section for pallet general info
    Widget palletDetails = Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColor().milkWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pallet No:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          (pallet == null)
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: 200,
                    height: 45,
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                )
              : Text(
                  pallet!.palletNo,
                  style: TextStyle(
                    fontSize: 40,
                    color: AppColor().tealBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
          Divider(color: Colors.grey.shade400, indent: 10, endIndent: 10),
          Row(children: [
            const Text(
              'Status: ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            (pallet == null)
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 130,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : Text(
                    pallet!.status,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColor().tealBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
            IconButton(
              onPressed: (pallet == null)
                  ? null
                  : () => showQuickPICInfo(context, pallet!),
              icon: Icon(Icons.info_outline, color: AppColor().tealBlue),
            )
          ]),
          const SizedBox(height: 10),
          createPalletDetails('Type', pallet?.palletType.capitalize()),
          const SizedBox(height: 5),
          createPalletDetails('Destination', pallet?.destination.capitalize()),
          const SizedBox(height: 5),
          createPalletDetails('Lorry No', pallet?.lorryNo),
          const SizedBox(height: 5),
          createPalletDetails(
            'Forklift Driver',
            pallet?.assignToUserName.capitalize(),
          ),
          const SizedBox(height: 5),
        ]),
      ),
    );

    Widget signatureArea = Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 0.5,
            color: AppColor().blueZodiac,
          ),
        ),
        tilePadding: const EdgeInsets.only(left: 8),
        collapsedBackgroundColor: Colors.grey.shade200,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text(
          'Signature:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children: [
          Container(
            child: pallet == null
                ? null
                : pallet!.signature.attachmentFullPath != ""
                    ? const Column(
                        children: [
                          Text('Signature here'),
                        ],
                      )
                    : const Text('No signature available'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );

    // Create simple table for pallet items
    Widget palletActivityItems = SizedBox(
      child: DataTable(
        border: TableBorder.all(width: 0.3),
        headingTextStyle: const TextStyle(fontWeight: FontWeight.w600),
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Qty')),
        ],
        rows: [
          if (pallet != null)
            ...pallet!.palletActivityDetail!
                .map(
                  (item) => DataRow(cells: [
                    DataCell(
                      Text(item.customerName.toUpperCase()),
                    ),
                    DataCell(
                      Text(item.qty.toString()),
                    ),
                  ]),
                )
                .toList(),
          DataRow(cells: [
            const DataCell(Text('Total')),
            DataCell(Text(itemTotal.toString())),
          ]),
        ],
      ),
    );

    // Create expansion tile for pallet item
    Widget palletItemsArea = Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 0.5,
            color: AppColor().blueZodiac,
          ),
        ),
        onExpansionChanged: (value) {
          setState(() {
            expanded = value;
          });
        },
        tilePadding: const EdgeInsets.only(left: 8),
        childrenPadding: const EdgeInsets.only(left: 10, right: 10),
        collapsedBackgroundColor: Colors.grey.shade200,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: (expanded)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Items List:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: AppColor().blueZodiac,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton.icon(
                      onPressed: (pallet == null)
                          ? null
                          : () => Navigator.of(context).push(SlideRoute(
                                page: ActivityDetailsTableView(
                                  palletActivityId: pallet!.palletActivityId,
                                  activityItems: pallet!.palletActivityDetail,
                                ),
                                toRight: true,
                              )),
                      icon: const Icon(
                        FluentIcons.edit_24_filled,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Text(
                'Items List:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: pallet!.palletActivityDetail!.isNotEmpty
                ? palletActivityItems
                : const Center(
                    child: Text('No pallet items available'),
                  ),
          )
        ],
      ),
    );

    // Create display button area
    Widget displayButton = Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(150, 50),
              backgroundColor: pallet?.palletLocation == "outbound"
                  ? AppColor().greyGoose.withOpacity(0.8)
                  : AppColor().blueZodiac,
              elevation: pallet?.palletLocation == "outbound" ? 0 : 3,
            ),
            onPressed: pallet == null
                ? null
                : pallet!.palletLocation == "outbound"
                    ? () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                const Text('This pallet is already outBound.'),
                            backgroundColor: Colors.grey.shade600,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    : _movePallet,
            icon: const Icon(
              Icons.compare_arrows_sharp,
              color: Colors.white,
            ),
            label: const Text(
              'Move',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(150, 50),
              backgroundColor: (pallet?.assignByUserName != '')
                  ? AppColor().greyGoose.withOpacity(0.8)
                  : AppColor().blueZodiac,
              elevation: pallet?.assignByUserName != "" ? 0 : 3,
            ),
            onPressed: pallet == null
                ? null
                : (pallet!.assignByUserName != '')
                    ? () {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                            'This pallet is already been assigned.',
                          ),
                          backgroundColor: Colors.grey.shade600,
                          duration: const Duration(seconds: 2),
                        ));
                      }
                    : _assignJob,
            icon: const Icon(
              FluentIcons.person_add_24_filled,
              color: Colors.white,
            ),
            label: const Text(
              'Assign',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ]),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(140, 50),
              backgroundColor: (pallet!.status != 'Loading To Truck')
                  ? AppColor().greyGoose.withOpacity(0.8)
                  : AppColor().blueZodiac,
              elevation: pallet!.status != 'Loading To Truck' ? 0 : 3,
            ),
            onPressed: pallet!.status == 'Loading To Truck'
                ? _signatureBox
                : () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'This pallet status need to be --Loading To Truck--'),
                        backgroundColor: Colors.grey.shade600,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
            icon: const Icon(
              FluentIcons.signature_24_filled,
              color: Colors.white,
            ),
            label: const Text(
              'Signature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minimumSize: const Size(150, 50),
              backgroundColor: AppColor().blueZodiac,
              elevation: 3,
            ),
            onPressed: pallet == null ? null : () {},
            icon: const Icon(Icons.print_outlined, color: Colors.white),
            label: const Text(
              'Print',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ])
      ]),
    );

    return Scaffold(
      appBar: customAppBar("Pallet Details"),
      backgroundColor: AppColor().milkWhite,
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: Column(children: [
              // Show pallet general info
              palletDetails,

              // Show PIC Signature
              signatureArea,

              // Show pallet item table info
              palletItemsArea,

              // Show function button info
              displayButton,
            ]),
          ),
        ),
        if (reqLoading)
          Container(
            color: const Color.fromRGBO(255, 255, 255, .8),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          )
      ]),
    );
  }

  void _movePallet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return AlertDialog(
          elevation: 3.0,
          backgroundColor: AppColor().milkWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          title: const Center(
            child: Text(
              'Move Pallet',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          content: Container(
            alignment: Alignment.center,
            height: 80,
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: 'Confirm to move this pallet from ',
                    style: TextStyle(
                      color: AppColor().matteBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: 'INBOUND ',
                    style: TextStyle(
                      color: AppColor().matteBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                  TextSpan(
                    text: 'to ',
                    style: TextStyle(
                      color: AppColor().matteBlack,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: 'OUTBOUND',
                    style: TextStyle(
                      color: AppColor().matteBlack,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.only(top: 8, bottom: 5),
          actions: [
            ListTile(
              title: Text(
                "Move Pallet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade500,
                ),
              ),
              onTap: () => Navigator.pop(context, 1),
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
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.pop(context),
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
    ).then((value) {
      if (value != 1) return;
      movePalletToOutBound();
    });
  }

  movePalletToOutBound() {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Sending request...'),
      backgroundColor: Colors.blue.shade300,
      duration: const Duration(seconds: 5),
    ));

    setState(() {
      reqLoading = true;
    });

    ApiServices.pallet.move(pallet!.palletActivityId).then((value) {
      if (!value) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Move pallet request failed. Please try again.',
          ),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 5),
        ));
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Move pallet request successfull.'),
            backgroundColor: Colors.blue.shade300,
            duration: const Duration(seconds: 5),
          ),
        );
      }

      setState(() {
        reqLoading = false;
      });
    });
  }

  void _assignJob() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return ScaffoldMessenger(
          child: Builder(builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (assignKey.currentState?.loading == false) {
                    Navigator.pop(context); // Dismiss dialog when tap outside
                  }
                },
                child: GestureDetector(
                  onTap: () {}, // Prevent dialog to close when tap inside
                  child: AlertDialog(
                    backgroundColor: AppColor().milkWhite,
                    elevation: 3.0,
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    title: const Center(
                      child: Text(
                        "Assign Job",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    content: Column(mainAxisSize: MainAxisSize.min, children: [
                      AssignJobForm(
                        key: assignKey,
                        drivers: drivers,
                        palletActivityId: pallet!.palletActivityId,
                        lorryNo: pallet!.lorryNo,
                      ),
                    ]),
                    actionsPadding: const EdgeInsets.only(top: 8, bottom: 5),
                    actions: [
                      ListTile(
                        title: Text(
                          "Assign Job",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade500,
                          ),
                        ),
                        onTap: () {
                          if (assignKey.currentState?.loading == false) {
                            assignKey.currentState?.submit();
                          }
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
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          if (assignKey.currentState?.loading == false) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: child,
          ),
        );
      },
    );
  }

  // Create Signature pop up box
  Future<void> _signatureBox() {
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
              elevation: 3.0,
              backgroundColor: AppColor().milkWhite,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              title: const Center(
                child: Text(
                  'Pallet Signature',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              content: SizedBox(
                height: 280,
                width: double.maxFinite,
                child: SfSignaturePad(
                  key: signaturePadKey,
                  minimumStrokeWidth: 1,
                  maximumStrokeWidth: 3,
                  strokeColor: Colors.blue,
                  backgroundColor: Colors.white,
                  onDrawEnd: () {
                    _signature = true;
                  },
                ),
              ),
              actions: <Widget>[
                Column(
                  children: [
                    ListTile(
                      title: Text('Clear Signature',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue.shade500,
                            fontWeight: FontWeight.w600,
                          )),
                      onTap: () {
                        _signature = false;
                        signaturePadKey.currentState!.clear();
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
                      title: Text(
                        'Submit Signature',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.blue.shade500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () async {
                        if (_signature) {
                          await _sendSignature(pallet!.palletActivityId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Please sign the pallet before submit.'),
                              backgroundColor: Colors.red.shade300,
                              duration: const Duration(seconds: 5),
                            ),
                          );
                        }
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
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _signature = false;
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _sendSignature(int palletActivityId) async {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sending the signature..'),
        backgroundColor: Colors.blue.shade300,
        duration: const Duration(seconds: 5),
      ),
    );

    // Save the signature as a file
    ui.Image signature = await signaturePadKey.currentState!.toImage();

    ByteData? byteData =
        await signature.toByteData(format: ui.ImageByteFormat.png);
    Uint8List signatureBytes = byteData!.buffer.asUint8List();

    //Create temporary directory to store the signature image
    final tempDir = await getTemporaryDirectory();
    File signatureFile = File('${tempDir.path}/${pallet!.palletNo}.jpeg');
    await signatureFile.writeAsBytes(signatureBytes);

    var res = await ApiServices.signature
        .sendSignature(palletActivityId, signatureFile, isAccess);

    if (mounted) {
      if (res.statusCode != HttpStatus.ok) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to send signature. Please try again.'),
            backgroundColor: Colors.red.shade300,
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Successfully sign the pallet.'),
            backgroundColor: Colors.green.shade300,
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }
    }
  }
}
