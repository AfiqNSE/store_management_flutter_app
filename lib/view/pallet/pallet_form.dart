import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
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
  List<bool> _selectedPalletType = <bool>[false, false];
  String? _selectedDestination = Constant().destination[0];

  void _resetForm() {
    palletNo.clear();
    lorryNo.clear();
    setState(() {
      _selectedPalletLocation = [false, false];
      _selectedPalletType = [false, false];
      _selectedDestination = Constant().destination[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Open Pallet Form'),
      backgroundColor: AppColor().milkWhite,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                // Pallet form area
                palletForm(),
                // Adding button for clear and submit form
                formButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form palletForm() => Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTextLabel('Pallet Number: '),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: TextFormField(
                controller: palletNo,
                cursorHeight: 22,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                decoration: customTextFormFieldDeco('Enter Pallet Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pallet number';
                  }
                  return null;
                },
              ),
            ),
            customTextLabel('Pallet Location: '),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: customToggleButton(
                  _selectedPalletLocation, Constant().palletLocation),
            ),
            customTextLabel('Pallet Type: '),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: customToggleButton(
                  _selectedPalletType, Constant().palletType),
            ),
            customTextLabel('Destination: '),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: destinationDropDown(),
            ),
            customTextLabel('Lorry No: '),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: TextFormField(
                controller: lorryNo,
                cursorHeight: 22,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
                decoration: customTextFormFieldDeco('Enter Lorry Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lorry number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      );

  // Button to submit & clear the form data
  Widget formButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(const Size(double.infinity, 40)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColor().blueZodiac,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate() &&
                  _selectedPalletLocation.contains(true) &&
                  _selectedPalletType.contains(true) &&
                  _selectedDestination != Constant().destination[0]) {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Successfully open pallet.'),
                    backgroundColor: Colors.green.shade300,
                    duration: const Duration(seconds: 5),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please complete the form.'),
                    backgroundColor: Colors.red.shade300,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            },
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
            style: ButtonStyle(
              minimumSize:
                  MaterialStateProperty.all(const Size(double.infinity, 40)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    color: Color.fromRGBO(102, 153, 204, 1),
                    width: 1.3,
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                AppColor().milkWhite,
              ),
            ),
            onPressed: () {
              _resetForm();
            },
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
  }

  // Create toggle button for pallet location and type
  Widget customToggleButton(
    List<bool> selected,
    List<Widget> items,
  ) {
    return ToggleButtons(
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < selected.length; i++) {
            selected[i] = i == index;
          }
        });
      },
      borderColor: Colors.grey,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderWidth: 1.3,
      selectedBorderColor: Colors.green[700],
      selectedColor: Colors.white,
      fillColor: Colors.green[200],
      constraints: const BoxConstraints(
        minHeight: 40.0,
        minWidth: 100.0,
      ),
      isSelected: selected,
      children: items,
    );
  }

  Widget destinationDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                Constant().destination[0],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: Constant()
            .destination
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: _selectedDestination,
        onChanged: (String? value) {
          setState(() {
            _selectedDestination = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 35,
          width: 200,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: AppColor().milkWhite,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
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
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
          ),
        ),
      ),
    );
  }
}
