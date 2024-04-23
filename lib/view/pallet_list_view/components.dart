import 'package:flutter/material.dart';

Future palletPICInfo(
  BuildContext context,
  String openBy,
  String openOn,
  String moveBy,
  String moveOn,
  String assignBy,
  String assignOn,
  String loadBy,
  String loadOn,
  String driverName,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text(
          "Person In Charge",
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 310,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Divider(
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Open By:'),
                  Text(openBy),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Open On:'),
                  Text(openOn),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Move By:'),
                  Text(moveBy),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Move On:'),
                  Text(moveOn),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Assign By:'),
                  Text(assignBy),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Assign On:'),
                  Text(assignOn),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Load By:'),
                  Text(loadBy),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Load On:'),
                  Text(loadOn),
                ],
              ),
              Divider(
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              const Text('Received & Signed by: '),
              Text(driverName),
              const SizedBox(height: 5),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
