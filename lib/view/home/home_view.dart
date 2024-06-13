import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/components/search_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/models/summary.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/utils/storage_utils.dart';
import 'package:store_management_system/view/home/notification_view.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';
import 'package:store_management_system/view/pallet/pallet_form.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController searchController = TextEditingController();

  List<dynamic> pallets = List.empty();
  List<dynamic> searchPallet = List.empty();

  late String formattedDate;
  String greetingMessage = "";

  @override
  void initState() {
    super.initState();
    _getDate();
    _greetingMeesage();
    _getSummary().then((value) {
      if (value > 0) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => customShowToast(
            context,
            'Failed to get data from server, try again later.',
            Colors.red.shade300,
            false,
          ),
        );
      }
    });
  }

  void _getDate() {
    final DateTime now = DateTime.now();
    final dateFormatter = DateFormat('yyyy, MMMM dd');
    formattedDate = dateFormatter.format(now);
  }

  void _greetingMeesage() async {
    var timeNow = DateTime.now().hour;
    if (timeNow < 12) {
      greetingMessage = 'Good Morning,';
    } else if (timeNow >= 12 && timeNow <= 16) {
      greetingMessage = 'Good Afternoon,';
    } else if (timeNow > 16) {
      greetingMessage = 'Good Evening,';
    }

    String name = await Storage.instance.getDisplayName();
    if (name == "") {
      greetingMessage = "$greetingMessage Staff!";
    } else {
      int index = name.indexOf(" ");
      if (index > 0) {
        name = name.substring(0, index);
      }

      greetingMessage = "$greetingMessage ${name.capitalize()}!";
    }

    setState(() {});
  }

  Future<int> _getSummary() async {
    var res = await ApiServices.pallet.summary();

    if (res.containsKey("err")) {
      return res["err"];
    }

    if (mounted) Provider.of<SummaryNotifier>(context, listen: false).set(res);
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget quickbar = Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: SizedBox(
        height: 110,
        child: GridView.count(
          padding: const EdgeInsets.all(8),
          mainAxisSpacing: 10,
          scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          children: <Widget>[
            createQuickAction(
              'Open Forms',
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (contex) => const PalletFormView(),
                ))
              },
              icon: FluentIcons.form_new_24_filled,
            ),
            createQuickAction(
              'Scan Pallet',
              onTap: scanPallet,
              icon: FluentIcons.barcode_scanner_24_filled,
            ),
            createQuickAction(
              'Search',
              onTap: search,
              icon: FluentIcons.search_24_filled,
            ),
            createQuickAction(
              'More',
              onTap: () => customShowToast(
                context,
                "This feature will be available soon.",
                Colors.grey.shade600,
                true,
              ),
              icon: FluentIcons.grid_dots_24_filled,
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor().blueZodiac,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).push(
                SlideRoute(page: const NotificationView(), toRight: false),
              ),
              icon: const Icon(Icons.notifications_active_outlined, size: 28),
            ),
          ),
        ],
      ),
      extendBody: true,
      backgroundColor: AppColor().blueZodiac,
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Column(children: [
            Text(
              formattedDate,
              style: TextStyle(
                color: AppColor().milkWhite,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              greetingMessage,
              textAlign: TextAlign.center,
              style: GoogleFonts.lora(
                textStyle: TextStyle(
                  color: AppColor().deepSaffron,
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ]),
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
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        'What would you like to do today?',
                        style: TextStyle(
                          color: Color.fromRGBO(40, 40, 43, 1),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    quickbar,
                    Divider(
                      color: Colors.grey.shade400,
                      indent: 8,
                      endIndent: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
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
                            onPressed: refreshSummary,
                            icon: const Icon(
                              Icons.refresh_outlined,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    Consumer<SummaryNotifier>(
                      builder: (context, summary, child) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 5, 8, 90),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                createSummaryCard("Pallets", summary.pallets),
                                createSummaryCard("inbound", summary.inBound),
                                createSummaryCard("outbound", summary.outBound),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget createQuickAction(
    String text, {
    required void Function() onTap,
    required IconData icon,
  }) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
              Icon(icon, size: 28, color: Colors.grey.shade800),
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
    String barcodeScanRes = "-1";

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );
    } on PlatformException {
      if (mounted) {
        customShowToast(
          context,
          'Failed to get platform version.',
          Colors.red.shade300,
          false,
        );
      }
      barcodeScanRes = '-1';
    }

    if (barcodeScanRes == '-1') {
      return;
    }

    Pallet? pallet;

    Map<String, dynamic> res = await ApiServices.pallet.getByNo(
      barcodeScanRes,
    );

    if (mounted) {
      if (res.containsKey("err")) {
        customShowToast(
          context,
          'No pallet number found in the database',
          Colors.red.shade300,
          true,
        );
      } else {
        pallet = Pallet.fromMap(res);
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => PalletDetailsView(
                    palletActivityId: pallet!.palletActivityId,
                  )),
        );
      }
    }
  }

  void search() => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: AppColor().greyGoose.withOpacity(0.3),
            elevation: 3.0,
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            content: PalletSearch(
              controller: searchController,
              onSearch: (value) {
                setState(() {});
              },
            ),
          );
        },
      );

  Widget createSummaryCard(String text, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black,
        child: Container(
          height: 90,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(width: 0.3, color: Colors.grey.shade600),
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
                            text: text.toUpperCase(),
                            style: TextStyle(
                              color: AppColor().matteBlack,
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

  void refreshSummary() {
    _getSummary().then((value) {
      if (value > 0) {
        customShowToast(
          context,
          "Failed to get data from server, try again later.",
          Colors.red.shade300,
          true,
        );
      }
    });
  }
}
