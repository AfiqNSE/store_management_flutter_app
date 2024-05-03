import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';

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
      backgroundColor: AppColor().milkWhite,
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
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          backgroundColor: AppColor().milkWhite,
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text(
                  'General',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Pallets',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
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
              color: AppColor().milkWhite,
              child: const Center(
                child: Text(
                  "No New Notification",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Container(
              color: AppColor().milkWhite,
              child: const Center(
                child: Text(
                  "No New Notification",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
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
