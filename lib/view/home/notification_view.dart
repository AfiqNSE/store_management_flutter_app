import 'package:flutter/material.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 237, 237, 1),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: notificationCategories(),
          ),
        ],
      ),
    );
  }

  Widget notificationCategories() {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              "Your Notifications",
              style: TextStyle(
                color: Color.fromRGBO(40, 40, 43, 1),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: const Color.fromRGBO(252, 252, 252, 1),
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text(
                  'General',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Pallets',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(
              color: const Color.fromRGBO(252, 252, 252, 1),
              child: const Center(
                child: Text(
                  "No New Notification",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
            ),
            Container(
              color: const Color.fromRGBO(252, 252, 252, 1),
              child: const Center(
                child: Text(
                  "No New Notification",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color.fromRGBO(40, 40, 43, 1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
