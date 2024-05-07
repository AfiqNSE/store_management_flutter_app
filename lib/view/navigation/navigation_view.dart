import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/view/pallet/pallet_view.dart';
import 'package:store_management_system/view/account/account_view.dart';
import 'package:store_management_system/view/home/home_view.dart';
import 'package:store_management_system/view/search_history/search_history_view.dart';

class NavigationTabView extends StatefulWidget {
  const NavigationTabView({super.key});

  @override
  State<NavigationTabView> createState() => _NavigationTabViewState();
}

class _NavigationTabViewState extends State<NavigationTabView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabSelection);
    // Run code required to handle interacted messages
    setupInteractedMessage();
  }

  // Handle notification interaction
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  // Handle the data property of the message
  void _handleMessage(RemoteMessage message) {
    debugPrint(message.toString());
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //     arguments: ChatArguments(message),
    //   );
    // }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().milkWhite,
      extendBody: true,
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const <Widget>[
          HomeView(),
          PalletView(),
          PalletHistoryView(),
          AccountView(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: AppColor().blueZodiac,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: GNav(
              style: GnavStyle.google,
              curve: Curves.easeInCubic,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.white24,
              gap: 5,
              selectedIndex: _currentIndex,
              padding: const EdgeInsets.all(11),
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                  onPressed: () {
                    _tabController.animateTo(0);
                  },
                ),
                GButton(
                  icon: Icons.format_list_bulleted_outlined,
                  text: 'Pallets',
                  onPressed: () {
                    _tabController.animateTo(1);
                  },
                ),
                GButton(
                  icon: FluentIcons.search_24_filled,
                  text: 'Search',
                  onPressed: () {
                    _tabController.animateTo(2);
                  },
                ),
                GButton(
                  icon: FluentIcons.person_accounts_24_filled,
                  text: 'Account',
                  onPressed: () {
                    _tabController.animateTo(3);
                  },
                ),
              ],
              onTabChange: (index) {
                setState(() {
                  _tabController.animateTo(index);
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
