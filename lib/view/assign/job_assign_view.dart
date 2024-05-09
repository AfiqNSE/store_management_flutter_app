import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/components/pallet_components.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';

class JobAssignView extends StatefulWidget {
  const JobAssignView({super.key});

  @override
  State<JobAssignView> createState() => _JobAssignViewState();
}

class _JobAssignViewState extends State<JobAssignView>
    with TickerProviderStateMixin {
  List<String> confirmJobList = List.empty(growable: true);
  List<Pallet> jobAssignedList = List.empty(growable: true);

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getAssignedJob();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  getAssignedJob() async {
    List<dynamic> res = await ApiServices.pallet.assignJob();

    if (res.isEmpty) {
      return;
    }
    jobAssignedList = res.map((e) => Pallet.fromMap(e)).toList();

    setState(() {});
    return;
  }

  @override
  Widget build(BuildContext context) {
    // job assign content tab
    Widget jobAssignedContent(index) => Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3.0,
            color: Colors.amber.shade200,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PalletDetailsView(
                            palletActivityId:
                                jobAssignedList[index].palletActivityId,
                          )),
                );
              },
              title: Text(
                Constant.jobAssignedListTest[index],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                jobAssignedList[index].palletLocation,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: IconButton(
                onPressed: () => confirmDialogBox(),
                icon: const Icon(FluentIcons.clipboard_more_24_filled),
              ),
            ),
          ),
        );

    // confirm job content tab
    Widget confirmJobContent(index) => Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 3.0,
              color: Colors.blue.shade200,
              child: ListTile(
                  onTap: () {
                    // Comment this part for right now since the BE still in progress
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PalletDetailsView(
                                palletNo: Constant.jobAssignedListTest[index],
                              )),
                    );
                  },
                  title: Text(
                    Constant.confirmJobListTest[index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: const Text(
                    'outBound/inBound',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing:
                      const Icon(FluentIcons.clipboard_checkmark_24_filled))),
        );

    // Create Tab categories; All, InBound, OutBound
    Widget palletCategories() {
      Widget appBarTitle = const Text(
        "Today's Job Assign",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      );

      return DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: appBarTitle,
            ),
            backgroundColor: AppColor().milkWhite,
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColor().blueZodiac,
              indicatorColor: AppColor().blueZodiac,
              tabs: const <Widget>[
                Tab(
                  child: Text(
                    'Job Assigned',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Confirm Job',
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: jobAssignedList.isEmpty
                      ? const Center(child: Text('No job assign for today'))
                      : ListView.builder(
                          itemCount: jobAssignedList.length,
                          itemBuilder: ((context, index) =>
                              jobAssignedContent(index))),
                ),
              ),
              Container(
                color: AppColor().milkWhite,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Constant.confirmJobListTest.isEmpty
                      ? const Center(child: Text('No job confirm for today'))
                      : ListView.builder(
                          itemCount: Constant.confirmJobListTest.length,
                          itemBuilder: ((context, index) =>
                              confirmJobContent(index))),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: palletCategories(),
          ),
        ],
      ),
    );
  }

  confirmDialogBox() => showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: Colors.white,
          elevation: 3.0,
          title: const Text(
            'Job Confirmation',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text('Confirm to accept this assigned job?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColor().yaleBlue,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColor().yaleBlue,
                ),
              ),
            ),
          ],
        );
      });
}
