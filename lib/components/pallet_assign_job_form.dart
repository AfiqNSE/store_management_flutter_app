import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';

class AssignJobForm extends StatefulWidget {
  final List<dynamic> drivers;
  final int palletActivityId;
  final String lorryNo;

  const AssignJobForm({
    super.key,
    required this.drivers,
    required this.palletActivityId,
    this.lorryNo = "",
  });

  @override
  State<StatefulWidget> createState() => AssignJobFormState();
}

class AssignJobFormState extends State<AssignJobForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController lorryNo = TextEditingController();

  String? _selectedForkliftDriver;
  String forkliftDriverErr = "";

  bool loading = false;

  @override
  void initState() {
    super.initState();
    lorryNo.text = widget.lorryNo;
  }

  @override
  Widget build(BuildContext context) {
    Widget forkliftDriverDropDown = DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Padding(
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
        items: widget.drivers
            .map(
              (dynamic item) => DropdownMenuItem<String>(
                value: item["guid"],
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    item["displayName"] == ""
                        ? item["loginName"].toString().capitalizeOnly()
                        : item["displayName"],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
            .toList(),
        value: _selectedForkliftDriver,
        onChanged: loading
            ? null
            : (String? value) {
                _selectedForkliftDriver = value;
                forkliftDriverErr = "";
                setState(() {});
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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      width: double.maxFinite,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        customTextLabel('Forklift Driver:'),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: forkliftDriverDropDown,
        ),
        if (forkliftDriverErr != "") customTextErr(forkliftDriverErr),
        customTextLabel('Lorry No:'),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: TextFormField(
              controller: lorryNo,
              cursorHeight: 22,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
              decoration: customTextFormFieldDeco('Enter Lorry Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter lorry number';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              enabled: !loading,
            ),
          ),
        ),
      ]),
    );
  }

  submit() {
    setState(() {
      loading = true;
    });

    if (!_validate()) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please complete the form.'),
        backgroundColor: Colors.red.shade300,
        duration: const Duration(seconds: 5),
      ));

      return;
    }

    ApiServices.pallet
        .assign(
      _selectedForkliftDriver,
      lorryNo.text,
      widget.palletActivityId,
    )
        .then(
      (value) {
        if (!value) {
          setState(() {
            loading = false;
          });

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
                content: const Text('Server error, please try again later.'),
                backgroundColor: Colors.red.shade300,
                duration: const Duration(seconds: 5),
              ))
              .closed
              .then((value) => Navigator.pop(context));

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
            .then((value) {
          Navigator.pop(context);
          setState(() {
            Provider.of<PalletNotifier>(context, listen: false)
                .update(widget.palletActivityId);
          });
        });
      },
    );
  }

  bool _validate() {
    bool v = _formKey.currentState!.validate();

    if (_selectedForkliftDriver != null) {
      forkliftDriverErr = "";
    } else {
      v = false;
      forkliftDriverErr = "Please choose a forklift driver";
    }

    return v;
  }
}
