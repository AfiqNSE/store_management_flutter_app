import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/utils/main_utils.dart';

class PalletFormView extends StatefulWidget {
  const PalletFormView({super.key});

  @override
  State<PalletFormView> createState() => _PalletFormViewState();
}

class _PalletFormViewState extends State<PalletFormView> {
  String? selectedValue;
  final List<bool> _selectedPalletLocation = <bool>[false, false];
  final List<bool> _selectedPalletType = <bool>[false, false];
  final List<String> items = [
    'Destination 1',
    'Destination 2',
    'Destination 3'
  ];

  final List<Widget> palletLocation = <Widget>[
    const Text('Inbound'),
    const Text('Outbound'),
  ];

  final List<Widget> palletType = <Widget>[
    const Text('Palletise'),
    const Text('Loose'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Open Pallet Form'),
      backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: SingleChildScrollView(
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
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pallet Number: ',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(252, 252, 252, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        height: 35,
                        child: TextField(
                          cursorHeight: 22,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Enter Pallet Number',
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
                    const Text(
                      'Pallet Location: ',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: customToggleButton(
                          _selectedPalletLocation, palletLocation),
                    ),
                    const Text(
                      'Pallet Type: ',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child:
                          customToggleButton(_selectedPalletType, palletType),
                    ),
                    const Text(
                      'Destination: ',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: destinationDropDown(),
                    ),
                    const Text(
                      'Lorry No: ',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 20),
                      child: Container(
                        height: 35,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(252, 252, 252, 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
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
                                const Color.fromRGBO(245, 254, 253, 1),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Clear Form',
                              style: TextStyle(
                                color: Colors.blue.shade600,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(31, 48, 94, 1),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Open Pallet',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customToggleButton(
    List<bool> selected,
    List<Widget> items,
  ) {
    return ToggleButtons(
      textStyle: const TextStyle(fontWeight: FontWeight.w500),
      onPressed: (int index) {
        setState(() {
          // The button that is tapped is set to true, and the others to false.
          for (int i = 0; i < selected.length; i++) {
            selected[i] = i == index;
          }
        });
      },
      borderColor: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.green[700],
      selectedColor: Colors.white,
      fillColor: Colors.green[200],
      color: const Color.fromRGBO(40, 40, 43, 1),
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
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Select Desination',
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
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(40, 40, 43, 1),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 35,
          width: 200,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(252, 252, 252, 1),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
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
          padding: EdgeInsets.only(
            left: 14,
            right: 14,
          ),
        ),
      ),
    );
  }
}
