import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';

class JobAssignView extends StatefulWidget {
  const JobAssignView({super.key});

  @override
  State<JobAssignView> createState() => _JobAssignViewState();
}

class _JobAssignViewState extends State<JobAssignView>
    with TickerProviderStateMixin {
  Map<int, Pallet> jobAssigned = {};
  List<Pallet> jobConfirmList = List.empty(growable: true);

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    getAssignedJob();
    getConfirmJob();
  }

  getAssignedJob() async {
    List<dynamic> res = await ApiServices.pallet.fetchAssignedJob();

    if (res.isEmpty) {
      return;
    }

    jobAssigned = {
      for (var element in res)
        element["palletActivityId"]: Pallet.fromMap(element)
    };

    setState(() {});
  }

  getConfirmJob() async {
    List<dynamic> res = await ApiServices.pallet.fetchConfirmedJob();

    if (res.isEmpty) {
      return;
    }

    jobConfirmList = res.map((e) => Pallet.fromMap(e)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget appBarTitle = const Text(
      "Today's Job Assign",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );

    // Create Tab categories; Job Assigned, Confirm Job
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
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
              Tab(
                child: Text(
                  'Confirm Job',
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
              padding: const EdgeInsets.only(top: 10),
              child: jobAssigned.isEmpty
                  ? const Center(child: Text('No job assign for today'))
                  : ListView.builder(
                      itemCount: jobAssigned.length,
                      itemBuilder: (context, index) =>
                          jobAssignedContent(index),
                    ),
            ),
            Container(
              color: AppColor().milkWhite,
              padding: const EdgeInsets.only(top: 10),
              child: jobConfirmList.isEmpty
                  ? const Center(child: Text('No job confirm for today'))
                  : ListView.builder(
                      itemCount: jobConfirmList.length,
                      itemBuilder: (context, index) => confirmJobContent(index),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Job assign content tab
  Widget jobAssignedContent(index) {
    int id = jobAssigned.keys.elementAt(index);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 3.0,
        color: Colors.amber.shade200,
        child: ListTile(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PalletDetailsView(palletActivityId: id),
          )),
          title: Text(
            jobAssigned[id]!.palletNo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            jobAssigned[id]!.palletLocation,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: IconButton(
            onPressed: () => confirmDialogBox(id),
            icon: const Icon(FluentIcons.clipboard_more_24_filled),
          ),
        ),
      ),
    );
  }

  // Confirm job content tab
  Widget confirmJobContent(index) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 3.0,
          color: Colors.blue.shade200,
          child: ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PalletDetailsView(
                      palletActivityId: jobConfirmList[index].palletActivityId,
                    ),
                  ),
                );
              },
              title: Text(
                jobConfirmList[index].palletNo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                jobConfirmList[index].palletLocation,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(FluentIcons.clipboard_checkmark_24_filled)),
        ),
      );

  confirmDialogBox(palletActivityId) {
    showDialog(
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
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          content: const Text('Confirm to accept this assigned job?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(0),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColor().yaleBlue),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(1),
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
      },
    ).then((value) {
      if (value != 1) return;

      ApiServices.pallet.confirm(palletActivityId).then((value) {
        if (value != true) {
          customShowToast(
            context,
            "Failed to confirm job, Please try again.",
            Colors.red.shade300,
          );

          return;
        }

        customShowToast(
          context,
          "Job is confirmed.",
          Colors.green.shade300,
        );

        jobConfirmList.add(jobAssigned[palletActivityId]!);
        jobAssigned.remove(palletActivityId);
        setState(() {});
      });
    });
  }
}
