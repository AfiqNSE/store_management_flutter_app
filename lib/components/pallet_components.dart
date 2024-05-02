import 'package:flutter/material.dart';
import 'package:store_management_system/models/pallet_model.dart';

Future showPalletItemsInfo(
  BuildContext context,
  List<Item> items,
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
            backgroundColor:
                const Color.fromRGBO(237, 237, 237, 1).withOpacity(0.9),
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
                  color: Color.fromRGBO(40, 40, 43, 1),
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
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 10),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: ((context, index) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "> ${items[index].name}",
                                    style: const TextStyle(
                                      color: Color.fromRGBO(40, 40, 43, 1),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Qty: ${items[index].quantity}",
                                    style: const TextStyle(
                                      color: Color.fromRGBO(40, 40, 43, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
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
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(114, 160, 193, 1),
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

Future showPalletPICInfo(
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
            backgroundColor:
                const Color.fromRGBO(237, 237, 237, 1).withOpacity(0.9),
            elevation: 3.0,
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            title: const Center(
              child: Text(
                "Person In Charge",
                style: TextStyle(
                  color: Color.fromRGBO(40, 40, 43, 1),
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
              height: 310,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Open By:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          openBy,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Open On:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          openOn,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Move By:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          moveBy,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Move On:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          moveOn,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Assign By:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          assignBy,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Assign On:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          assignOn,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Load By:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          loadBy,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Load On:',
                          style: TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                        Text(
                          loadOn,
                          style: const TextStyle(
                            color: Color.fromRGBO(40, 40, 43, 1),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Received & Signed by: ',
                      style: TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                      ),
                    ),
                    Text(
                      driverName,
                      style: const TextStyle(
                        color: Color.fromRGBO(40, 40, 43, 1),
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            actionsPadding: const EdgeInsets.all(8),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(114, 160, 193, 1),
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

Widget createPalletDetails(String detail, String value, {int flex = 2}) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(detail,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(0, 102, 178, 1),
                fontWeight: FontWeight.w600,
              )),
        ),
        const Text(
          ": ",
          style: TextStyle(
            color: Color.fromRGBO(40, 40, 43, 1),
            fontSize: 15,
          ),
        ),
        Expanded(
          flex: flex,
          child: Text(
            value,
            style: const TextStyle(
              color: Color.fromRGBO(40, 40, 43, 1),
              fontWeight: FontWeight.w600,
              fontSize: 17,
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
