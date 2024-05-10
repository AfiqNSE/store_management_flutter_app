import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/view/pallet/pallet_item_edit.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

//TODO: Need to amend the assign job to get the list of forklift driver from B.E

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
  final _formKey = GlobalKey<FormState>();

  TextEditingController lorryNo = TextEditingController();

  Pallet? pallet;
  int itemTotal = 0;

  String forkliftDriverErr = "";
  String? _selectedForkliftDriver;

  bool _withSignature = false;
  bool expanded = false;

  bool loading = false;
  bool reqLoading = false;

  @override
  void initState() {
    super.initState();
    loadPallet();
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

    if (res.containsKey("err")) {
      pallet = Pallet.empty();
      // TODO: show an error
    } else {
      pallet = Pallet.fromMap(res);
      itemTotal = pallet!.items.fold(0, (sum, item) => sum + item.qty);
    }

    setState(() {});
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
          createPalletDetails('Forklift Driver', pallet?.assignToUserName),
          const SizedBox(height: 5),
        ]),
      ),
    );

    Widget signatureArea = Padding(
      padding: const EdgeInsets.fromLTRB(5, 20, 5, 0),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.only(left: 8),
        collapsedBackgroundColor: Colors.grey.shade200,
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text(
          'Signature:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children: const [Text('Signature Not Available'), SizedBox(height: 20)],
      ),
    );

    // Create table for pallet items
    Widget palletItems = SizedBox(
      width: double.maxFinite,
      child: DataTable(
        border: TableBorder.all(width: 0.5),
        columnSpacing: 35,
        headingTextStyle: const TextStyle(fontWeight: FontWeight.w600),
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Quantity')),
        ],
        rows: [
          if (pallet != null)
            ...pallet!.items
                .map(
                  (item) => DataRow(cells: [
                    DataCell(Text(item.customerName)),
                    DataCell(Text(item.qty.toString())),
                  ]),
                )
                .toList(),
          // Row for Total Quantity
          DataRow(cells: [
            const DataCell(Align(
              alignment: Alignment.center,
              child: Text('Total'),
            )), // Empty cell
            DataCell(Align(
              alignment: Alignment.center,
              child: Text(itemTotal.toString()),
            )),
          ]),
        ],
      ),
    );

    // Create expansion tile for pallet item
    Widget palletItemsArea = Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: ExpansionTile(
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
                  TextButton.icon(
                    onPressed: (pallet == null)
                        ? null
                        : () => Navigator.of(context).push(SlideRoute(
                              page: ItemTableEditView(
                                palletItems: pallet!.items,
                              ),
                              toRight: true,
                            )),
                    icon: Icon(
                      FluentIcons.edit_24_filled,
                      color: AppColor().blueZodiac,
                      size: 18,
                    ),
                    label: Text(
                      'Edit Table',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor().blueZodiac,
                      ),
                    ),
                  ),
                ],
              )
            : const Text(
                'Items List:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
        children: [palletItems, const SizedBox(height: 20)],
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
              backgroundColor: pallet!.palletLocation == "outbound"
                  ? AppColor().greyGoose.withOpacity(0.8)
                  : AppColor().blueZodiac,
              elevation: pallet!.palletLocation == "outbound" ? 0 : 3,
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
              backgroundColor: (pallet!.assignByUserName != '')
                  ? AppColor().greyGoose.withOpacity(0.8)
                  : AppColor().blueZodiac,
              elevation: pallet!.assignByUserName != "" ? 0 : 3,
            ),
            onPressed: pallet == null
                ? null
                : (pallet!.assignByUserName != '')
                    ? () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'This pallet is already been assigned.'),
                            backgroundColor: Colors.grey.shade600,
                            duration: const Duration(seconds: 2),
                          ),
                        );
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
              backgroundColor: AppColor().blueZodiac,
              elevation: 3,
            ),
            onPressed: pallet == null ? null : _signatureBox,
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

  void _assignJob() => showGeneralDialog(
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
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customTextLabel('Forklift Driver:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                child: forklifDriverDropDown(),
                              ),
                              if (_selectedForkliftDriver == null)
                                customTextErr(forkliftDriverErr),
                              customTextLabel('Lorry No.:'),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                child: TextFormField(
                                  controller: lorryNo,
                                  cursorHeight: 22,
                                  style: const TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                  decoration: customTextFormFieldDeco(
                                      'Enter Lorry Number'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter lorry number';
                                    }
                                    return null;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  enabled: !loading,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                    onTap: loading ? null : assignSubmit,
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
                    onTap: loading ? null : _cancelAssign,
                  ),
                ],
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                '--Select Forklift Driver--',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: loading ? Colors.grey : Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: Constant.forkliftDriverTest
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ))
            .toList(),
        value: _selectedForkliftDriver,
        onChanged: loading
            ? null
            : (String? value) {
                setState(() {
                  _selectedForkliftDriver = value;
                });
              },
        buttonStyleData: ButtonStyleData(
          height: 35,
          width: 210,
          decoration: BoxDecoration(
            border: Border.all(
              color: loading
                  ? Colors.grey.shade300
                  : forkliftDriverErr != ""
                      ? Colors.red.shade900
                      : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
            color: AppColor().milkWhite,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 210,
          decoration: BoxDecoration(
            color: AppColor().milkWhite,
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
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }

  assignSubmit() {
    setState(() {
      loading = true;
    });

    if (!assignValidate()) {
      setState(() {
        loading = false;
      });

      return;
    }

    assignJob().then((value) {
      if (value > 0) {
        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Server error, please try again later.'),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 5),
        ));

        return;
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: const Text('Successfully assign job.'),
            backgroundColor: Colors.green.shade300,
            duration: const Duration(seconds: 5),
          ))
          .closed
          .then((value) => Navigator.pop(context));
    });
  }

  bool assignValidate() {
    bool v = _formKey.currentState!.validate();

    if (_selectedForkliftDriver != null) {
      forkliftDriverErr = "";
    } else {
      v = false;
      forkliftDriverErr = "Please choose a forklift driver";
    }

    setState(() {});

    return v;
  }

  Future<int> assignJob() async {
    int res = await ApiServices.pallet.assignJob(
      _selectedForkliftDriver,
      pallet!.lorryNo,
      pallet!.palletActivityId,
    );

    return res;
  }

  // Create Signature pop up box
  Future<void> _signatureBox() {
    GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

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
                    _withSignature = true;
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
                        _withSignature = false;
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
                        if (_withSignature) {
                          // Save the signature as a file
                          // ui.Image signature =
                          //     await signaturePadKey.currentState!.toImage();

                          // ByteData? byteData = await signature.toByteData(
                          //     format: ui.ImageByteFormat.png);
                          // Uint8List signatureBytes =
                          //     byteData!.buffer.asUint8List();

                          // Create temporary directory to store the signature image
                          // final tempDir = await getTemporaryDirectory();
                          // File signatureFile = File(
                          //     '${tempDir.path}/${widget.docket.jobNo}-signature.jpeg');
                          // await signatureFile.writeAsBytes(signatureBytes);

                          Navigator.of(context).pop();

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Successfully sign pallet.'),
                              backgroundColor: Colors.green.shade300,
                              duration: const Duration(seconds: 5),
                            ),
                          );
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
                        _withSignature = false;
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

  void _cancelAssign() {
    Navigator.pop(context);
    lorryNo.clear();
    _selectedForkliftDriver = null;
    setState(() {});
  }
}
