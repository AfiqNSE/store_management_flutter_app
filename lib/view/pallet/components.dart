import 'package:flutter/material.dart';

Future palletItemsInfo(
  BuildContext context,
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
            backgroundColor: const Color.fromRGBO(245, 254, 253, 1),
            elevation: 3.3,
            title: const Text(
              "Pallets Info",
            ),
            content: const SizedBox(
              width: double.maxFinite,
              height: 310,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [],
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
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    },
  );
}

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
            backgroundColor: const Color.fromRGBO(245, 254, 253, 1),
            elevation: 3.3,
            title: const Center(
              child: Text(
                "Person In Charge",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
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
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    },
  );
}

Widget createPalletDetails(String detail, String value, {int flex = 2}) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(detail,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromRGBO(0, 102, 178, 1),
                fontWeight: FontWeight.w600,
              )),
        ),
        const Text(": ", style: TextStyle(fontSize: 15)),
        Expanded(
          flex: flex,
          child: Text(
            value,
            style: const TextStyle(
              color: Color.fromRGBO(40, 40, 43, 1),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

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
