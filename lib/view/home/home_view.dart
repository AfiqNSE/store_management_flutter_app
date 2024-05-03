import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/home/notification_view.dart';
import 'package:store_management_system/view/pallet/pallet_form.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String formattedDate;
  late String greetingMessage = '';

  @override
  void initState() {
    super.initState();
    _getDate();
    _greetingMeesage();
  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final dateFormatter = DateFormat('yyyy, MMMM dd');
    formattedDate = dateFormatter.format(now);
  }

  void _greetingMeesage() {
    var timeNow = DateTime.now().hour;
    if (timeNow <= 11.59) {
      greetingMessage = 'Good Morning, Staff!';
    } else if (timeNow > 12 && timeNow <= 16) {
      greetingMessage = 'Good Afternoon, Staff!';
    } else if (timeNow > 16) {
      greetingMessage = 'Good Evening, Staff!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().blueZodiac,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.push(context,
                    SlideRoute(page: const NotificationView(), toRight: false));
              },
              icon: const Icon(
                Icons.notifications_active_outlined,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      extendBody: true,
      backgroundColor: AppColor().blueZodiac,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
            child: Column(
              children: [
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: AppColor().milkWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(greetingMessage,
                    style: GoogleFonts.lora(
                      textStyle: TextStyle(
                        color: AppColor().deepSaffron,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColor().milkWhite,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
                border: Border.fromBorderSide(BorderSide(
                  color: AppColor().blueZodiac,
                )),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          children: [
                            Text(
                              'What would you like to do today?',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: SizedBox(
                          height: 110,
                          child: GridView.count(
                            padding: const EdgeInsets.all(8),
                            mainAxisSpacing: 10,
                            scrollDirection: Axis.horizontal,
                            crossAxisCount: 1,
                            children: <Widget>[
                              createFeaturesGrid(
                                'Open Forms',
                                onTap: () => {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (contex) =>
                                            const PalletFormView()),
                                  )
                                },
                                icon: FluentIcons.form_new_24_filled,
                              ),
                              createFeaturesGrid(
                                'Scan Pallet',
                                onTap: scanPallet,
                                icon: FluentIcons.barcode_scanner_24_filled,
                              ),
                              createFeaturesGrid(
                                'Language',
                                onTap: () {},
                                icon: Icons.language_outlined,
                              ),
                              createFeaturesGrid(
                                'More',
                                onTap: () {},
                                icon: FluentIcons.grid_dots_24_filled,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.shade400,
                        indent: 8,
                        endIndent: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Pallet's Summary",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.refresh_outlined,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 90),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              createSummaryCard(
                                "Pallets",
                                100,
                              ),
                              createSummaryCard(
                                "InBound",
                                60,
                              ),
                              createSummaryCard(
                                "OutBound",
                                40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createFeaturesGrid(
    String text, {
    required void Function() onTap,
    required IconData icon,
  }) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3.0,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor().milkWhite,
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: Colors.grey.shade800,
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  scanPallet() async {
    String qrScanRes = "-1";
    var scaffoldMessenger = ScaffoldMessenger.of(context);

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
    } on PlatformException {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: const Text('Failed to get platform version.'),
        backgroundColor: Colors.red.shade300,
        duration: const Duration(seconds: 3),
      ));

      throw ErrorDescription('Failed to get platform version.');
    }

    if (qrScanRes == '-1') {
      return;
    }

    try {
      //Store the qr value in here into a variable

      if (mounted) {
        Navigator.of(context).pop();
      }
    } on Exception {
      if (mounted) {
        scaffoldMessenger.showSnackBar(SnackBar(
          content: const Text('Unknown format, please scan again!'),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 5),
        ));
      }
    }
  }

  Widget createSummaryCard(
    String text,
    int value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black,
        child: Container(
          height: 90,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColor().milkWhite,
              width: 0.7,
            ),
            borderRadius: BorderRadius.circular(10),
            color: customCardColor(text),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: 'Total:\n',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            )),
                      ]),
                ),
                Text(
                  '$value',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
