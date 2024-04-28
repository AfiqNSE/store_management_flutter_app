import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet/pallet_form.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(31, 48, 94, 1),
        elevation: 0.0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(
              Icons.notifications_active_outlined,
              size: 26,
              color: Colors.white,
            ),
          ),
        ],
      ),
      extendBody: true,
      backgroundColor: const Color.fromRGBO(31, 48, 94, 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 50),
            child: Column(
              children: [
                const Text(
                  'THURSDAY, APRIL 16',
                  style: TextStyle(
                    color: Color.fromRGBO(252, 252, 252, 1),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('Good Morning, Staff!',
                    style: GoogleFonts.lora(
                      textStyle: const TextStyle(
                        color: Color.fromRGBO(255, 164, 57, 1),
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(252, 252, 252, 1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
                border: Border.fromBorderSide(BorderSide(
                  color: Color.fromRGBO(31, 48, 94, 1),
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
                                color: Color.fromRGBO(40, 40, 43, 1),
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
                                onTap: () {},
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
                                color: Color.fromRGBO(40, 40, 43, 1),
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
                        padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
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
              color: const Color.fromRGBO(211, 211, 211, 1),
              width: 1.2,
            ),
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Color.fromRGBO(40, 40, 43, 1),
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

  Widget createSummaryCard(
    String text,
    int value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        elevation: 3.0,
        shadowColor: Colors.black,
        child: Container(
          height: 90,
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(211, 211, 211, 1),
              width: 0.6,
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
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(40, 40, 43, 1),
                            )),
                      ]),
                ),
                Text(
                  '$value',
                  style: const TextStyle(
                    color: Color.fromRGBO(40, 40, 43, 1),
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
