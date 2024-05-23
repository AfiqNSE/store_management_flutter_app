import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/notif.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';

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
            labelColor: AppColor().blueZodiac,
            indicatorColor: AppColor().blueZodiac,
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
                      return notifList(notifier.notifs[index]);
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

  Widget notifList(Notif notif) {
    String title = "";
    String subtitle = "";
    switch (notif.code) {
      case 1:
        title = "New pallet opened";
        subtitle = "Pallet with no ${notif.palletNo} is opened";
        break;
      case 2:
        title = "Pallet has been moved";
        subtitle = "Pallet with no ${notif.palletNo} is moved to outbound";
        break;
      case 3:
        title = "A pallet has been assigned to you";
        subtitle = "Pallet with no ${notif.palletNo} is assigned to you";
        break;
      default:
    }

    String time = "";
    Duration diff = DateTime.now().difference(notif.createdOn);
    if (diff.inDays != 0) {
      time = (diff.inDays > 1)
          ? "${diff.inDays} days ago"
          : "${diff.inDays} day ago";
    } else if (diff.inHours != 0) {
      time = (diff.inHours > 1)
          ? "${diff.inHours} hours ago"
          : "${diff.inHours} hour ago";
    } else if (diff.inMinutes != 0) {
      time = (diff.inMinutes > 1)
          ? "${diff.inMinutes} minutes ago"
          : "${diff.inMinutes} minute ago";
    } else if (diff.inSeconds != 0) {
      time = (diff.inSeconds > 1)
          ? "${diff.inSeconds} seconds ago"
          : "${diff.inSeconds} second ago";
    } else {
      time = "Just now";
    }

    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(time),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PalletDetailsView(
          palletNo: notif.palletNo,
        ),
      )),
    );
  }
}
