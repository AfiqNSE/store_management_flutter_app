import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/notif.dart';

// TODO: design notifications list

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
    Provider.of<NotifNotifier>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Text(
              "Your Notifications",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          backgroundColor: AppColor().milkWhite,
          bottom: TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                child: Text(
                  'General',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              Tab(
                child: Text(
                  'Pallets',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
            ),
            Container(
              color: AppColor().milkWhite,
              child: Consumer<NotifNotifier>(
                builder: (context, notifier, child) {
                  if (notifier.notifs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No New Notification",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(notifier.notifs[index].palletNo),
                      );
                    },
                    itemCount: notifier.notifs.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
