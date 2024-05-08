import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class PalletDetailsView extends StatefulWidget {
  final Pallet? pallet;
  final String palletNo;

  /// Create a pallet details view, either pallet or palletNo is required.
  /// If pallet is given, palletNo will be ignored. Otherwise, it will search
  /// pallet with the palletNo.
  const PalletDetailsView({super.key, this.pallet, this.palletNo = ""});

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
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadPallet();
  }

  loadPallet() async {
    if (widget.pallet != null) {
      pallet = widget.pallet;
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
  }

  @override
  Widget build(BuildContext context) {
    // Create section for pallet general info
    Widget palletDetails = Container(
      alignment: Alignment.topCenter,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor().milkWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pallet No:',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Text(
              pallet!.palletNo,
              style: TextStyle(
                fontSize: 40,
                color: AppColor().tealBlue,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(color: Colors.grey.shade400, indent: 8, endIndent: 8),
            Row(children: [
              const Text(
                'Status: ',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Text(
                pallet!.status,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColor().tealBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await showQuickPICInfo(context, pallet!);
                },
                icon: Icon(Icons.info_outline, color: AppColor().tealBlue),
              )
            ]),
            const SizedBox(height: 10),
            createPalletDetails('Type', pallet!.palletType),
            const SizedBox(height: 5),
            createPalletDetails('Destination', pallet!.destination),
            const SizedBox(height: 5),
            createPalletDetails('Lorry No', pallet!.lorryNo),
            const SizedBox(height: 5),
            createPalletDetails('Forklift Driver', ''),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );

    // Create table for pallet items
    Widget palletItems = SingleChildScrollView(
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
          ...pallet!.items
              .map(
                (item) => DataRow(cells: [
                  DataCell(Text(item.customerName)),
                  DataCell(Text(item.qty.toString())),
                  DataCell(Row(children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ])),
                ]),
              )
              .toList(),
          // Row for Total Quantity
          DataRow(cells: [
            const DataCell(Text('Total')), // Empty cell
            DataCell(Align(child: Text(itemTotal.toString()))),
            const DataCell(SizedBox.shrink()), // Empty cell
          ]),
        ],
      ),
    );

    // Create expansion tile for pallet item
    Widget palletItemsArea = ExpansionTile(
      collapsedBackgroundColor: AppColor().greyGoose,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: const Text(
        'Pallet Items:',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      children: [palletItems, const SizedBox(height: 20)],
    );

    // Create display button area
    Widget displayButton = Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(150, 50),
            backgroundColor: pallet!.palletLocation == "outbound"
                ? AppColor().greyGoose
                : AppColor().blueZodiac,
            elevation: 3,
          ),
          onPressed: pallet!.palletLocation == "outbound"
              ? () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('The pallet is already outBound.'),
                      backgroundColor: Colors.red.shade300,
                      duration: const Duration(seconds: 2),
                    ),
                  )
              : _movePallet,
          icon: Icon(
            Icons.compare_arrows_sharp,
            color: pallet!.palletLocation == "outbound"
                ? AppColor().matteBlack
                : Colors.white,
          ),
          label: Text(
            'Move',
            style: TextStyle(
              color: pallet!.palletLocation == "outbound"
                  ? AppColor().matteBlack
                  : Colors.white,
              fontSize: 18,
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
            minimumSize: MaterialStateProperty.all(const Size(150, 50)),
            backgroundColor: MaterialStateProperty.all<Color>(
              AppColor().blueZodiac,
            ),
            elevation: MaterialStateProperty.all(3),
          ),
          onPressed: _assignJob,
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
          onPressed: _signatureBox,
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
          onPressed: () {},
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
    ]);

    return Scaffold(
      appBar: customAppBar("Pallet Details"),
      backgroundColor: AppColor().milkWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(children: [
            const SizedBox(height: 10),
            // Show pallet general info
            palletDetails,

            const SizedBox(height: 10),
            // Show pallet item table info
            palletItemsArea,

            const SizedBox(height: 20),
            // Show function button info
            displayButton,
            const SizedBox(height: 20),
          ]),
        ),
      ),
    );
  }

  void _movePallet() => showGeneralDialog(
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
                    'Move Pallet',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
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
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );

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
                      onTap: loading
                          ? null
                          : () {
                              Navigator.pop(context);
                              _cancelAssign;
                            }),
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
        items: Constant()
            .forkliftDriver
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

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please complete the form.'),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 5),
        ),
      );

      return;
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: const Text('Successfully open pallet.'),
          backgroundColor: Colors.green.shade300,
          duration: const Duration(seconds: 5),
        ))
        .closed
        .then((value) => Navigator.pop(context));
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
    lorryNo.clear();
    _selectedForkliftDriver = null;
    setState(() {});
  }
}
