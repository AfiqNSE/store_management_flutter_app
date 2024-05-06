import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';

class PalletFormView extends StatefulWidget {
  const PalletFormView({super.key});

  @override
  State<PalletFormView> createState() => _PalletFormViewState();
}

class _PalletFormViewState extends State<PalletFormView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController palletNo = TextEditingController();
  TextEditingController lorryNo = TextEditingController();

  List<bool> _selectedPalletLocation = <bool>[false, false];
  String palletLocationErr = "";
  List<bool> _selectedPalletType = <bool>[false, false];
  String palletTypeErr = "";

  List<String> destinations = [];
  String destinationErr = "";
  String? _selectedDestination;

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getZones();
  }

  getZones() async {
    destinations = List<String>.from(await ApiServices.other.zones());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget destinationDropDown = DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "--Select Destination--",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: loading ? Colors.grey : Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        items: destinations
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        value: _selectedDestination,
        onChanged: loading
            ? null
            : (String? value) {
                setState(() {
                  _selectedDestination = value;
                });
              },
        buttonStyleData: ButtonStyleData(
          height: 35,
          width: 220,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            border: Border.all(
              color: loading
                  ? Colors.grey.shade300
                  : destinationErr != ""
                      ? Colors.red.shade900
                      : Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
            color: AppColor().milkWhite,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 220,
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

    Form palletForm = Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customTextLabel('Pallet Number: '),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: TextFormField(
            controller: palletNo,
            cursorHeight: 22,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            decoration: customTextFormFieldDeco('Enter Pallet Number'),
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(" "))],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter pallet number';
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enabled: !loading,
          ),
        ),
        customTextLabel('Pallet Location: '),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: customToggleButton(
            _selectedPalletLocation,
            Constant.palletLocations,
            error: palletLocationErr != "",
          ),
        ),
        if (!_selectedPalletLocation.contains(true))
          customTextErr(palletLocationErr),
        customTextLabel('Pallet Type: '),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: customToggleButton(
            _selectedPalletType,
            Constant.palletTypes,
            error: palletTypeErr != "",
          ),
        ),
        if (!_selectedPalletType.contains(true)) customTextErr(palletTypeErr),
        customTextLabel('Destination: '),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: destinationDropDown,
        ),
        if (_selectedDestination == null) customTextErr(destinationErr),
        customTextLabel('Lorry No: '),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          child: TextFormField(
            controller: lorryNo,
            cursorHeight: 22,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
            decoration: customTextFormFieldDeco('Enter Lorry Number'),
            enabled: !loading,
          ),
        ),
      ]),
    );

    // Button to submit & clear the form data
    Widget formButton = Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: AppColor().blueZodiac,
            ),
            onPressed: loading ? null : submit,
            child: Text(
              'Open Pallet',
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
            onPressed: loading ? null : _resetForm,
            child: Text(
              'Clear Form',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: customAppBar('Open Pallet Form'),
        backgroundColor: AppColor().milkWhite,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                // Pallet form area
                palletForm,
                // Adding button for clear and submit form
                formButton,
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // Create toggle button for pallet location and type
  Widget customToggleButton(
    List<bool> selected,
    List<String> items, {
    bool error = false,
  }) {
    return ToggleButtons(
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      onPressed: loading
          ? null
          : (int index) {
              setState(() {
                for (int i = 0; i < selected.length; i++) {
                  selected[i] = i == index;
                }
              });
            },
      borderColor: error ? Colors.red.shade900 : Colors.grey,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderWidth: error ? 1 : 1.3,
      selectedBorderColor: Colors.green[700],
      selectedColor: Colors.white,
      fillColor: Colors.green[200],
      constraints: const BoxConstraints(minHeight: 40.0, minWidth: 100.0),
      isSelected: selected,
      children: items.map((String e) => Text(e)).toList(),
    );
  }

  submit() {
    setState(() {
      loading = true;
    });

    if (!validate()) {
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

    openPallet().then((value) {
      if (value > 0) {
        setState(() {
          loading = false;
        });

        ScaffoldMessenger.of(context).clearSnackBars();
        if (value == 1) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'Pallet has already been used, please choose another pallet.',
            ),
            backgroundColor: Colors.red.shade300,
            duration: const Duration(seconds: 5),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Server error, please try again later.'),
            backgroundColor: Colors.red.shade300,
            duration: const Duration(seconds: 5),
          ));
        }

        return;
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: const Text('Successfully open pallet.'),
            backgroundColor: Colors.green.shade300,
            duration: const Duration(seconds: 5),
          ))
          .closed
          .then((value) => Navigator.pop(context));
    });
  }

  bool validate() {
    bool v = _formKey.currentState!.validate();
    if (_selectedPalletLocation.contains(true)) {
      palletLocationErr = "";
    } else {
      v = false;
      palletLocationErr = "Please select pallet location";
    }

    if (_selectedPalletType.contains(true)) {
      palletTypeErr = "";
    } else {
      v = false;
      palletTypeErr = "Please select pallet type";
    }

    if (_selectedDestination != null) {
      destinationErr = "";
    } else {
      v = false;
      destinationErr = "Please choose a destination";
    }

    setState(() {});

    return v;
  }

  Future<int> openPallet() async {
    String selectedLoc =
        Constant.palletLocations[_selectedPalletLocation.indexOf(true)];
    String selectedType =
        Constant.palletTypes[_selectedPalletType.indexOf(true)];

    int res = await ApiServices.pallet.open(
      palletNo.text,
      selectedLoc,
      selectedType,
      _selectedDestination!,
    );

    return res;
  }

  void _resetForm() {
    palletNo.clear();
    lorryNo.clear();

    _selectedPalletLocation = [false, false];
    _selectedPalletType = [false, false];
    _selectedDestination = null;

    setState(() {});
  }
}
