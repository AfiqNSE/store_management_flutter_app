import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/components/pallet_signature_component.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/models/pallet_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/view/pallet/pallet_details.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class JobView extends StatefulWidget {
  const JobView({super.key});

  @override
  State<JobView> createState() => _JobViewState();
}

class _JobViewState extends State<JobView> with TickerProviderStateMixin {
  final GlobalKey<SfSignaturePadState> signaturePadKey = GlobalKey();

  late List<Pallet> jobAssignedList;
  late List<Pallet> jobConfirmList;
  late List<Pallet> jobLoadingList;

  late TabController _tabController;
  bool isAccess = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  confirmJob(int palletActivityId) async {
    bool res = await ApiServices.pallet.confirm(palletActivityId);
    if (mounted) {
      if (res != true) {
        customShowToast(
          context,
          "Failed to confirm the job. Please try again.",
          Colors.red.shade300,
          false,
        );
        return;
      }
      customShowToast(
        context,
        "Job confirmation successful.",
        Colors.blue.shade300,
        false,
      );
    }
    setState(() {});
  }

  loadJob(int palletActivityId) async {
    bool res = await ApiServices.pallet.load(palletActivityId);
    if (mounted) {
      if (res != true) {
        customShowToast(
          context,
          "Failed to load the pallet onto the truck. Please try again",
          Colors.red.shade300,
          false,
        );
        return;
      }
      customShowToast(
        context,
        "Loading this pallet onto the truck.",
        Colors.blue.shade300,
        false,
      );
    }
    setState(() {});
  }

  closePallet(int palletActivityId) async {
    bool res = await ApiServices.pallet.close(palletActivityId);
    if (mounted) {
      if (res != true) {
        customShowToast(
          context,
          "Failed to close the pallet. Please try again.",
          Colors.red.shade300,
          true,
        );
        return;
      }
      showToast('').dismiss();
      customShowToast(
        context,
        "Pallet closed successfully.",
        Colors.blue.shade300,
        true,
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // job assign content tab
    Widget jobAssignedContent(index) => Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 0.3, color: Colors.grey.shade600)),
            elevation: 5,
            color: customCardColorStatus(jobAssignedList[index].status),
            child: ListTile(
              isThreeLine: true,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PalletDetailsView(
                          palletActivityId:
                              jobAssignedList[index].palletActivityId)),
                );
              },
              title: Text(
                jobAssignedList[index].palletNo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                "${jobAssignedList[index].openPalletLocation.capitalizeOnly()}\n${jobAssignedList[index].status}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
              ),
              trailing: IconButton(
                onPressed: () => moveToConfirmDialogBox(
                    jobAssignedList[index].palletActivityId),
                icon: const Icon(
                  FluentIcons.clipboard_task_add_24_filled,
                  size: 40,
                ),
              ),
            ),
          ),
        );

    // confirm job content tab
    Widget confirmJobContent(index) => Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  side: BorderSide(width: 0.3, color: Colors.grey.shade600)),
              elevation: 5,
              color: customCardColorStatus(jobConfirmList[index].status),
              child: ListTile(
                isThreeLine: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PalletDetailsView(
                              palletActivityId:
                                  jobConfirmList[index].palletActivityId,
                            )),
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
                  "${jobConfirmList[index].openPalletLocation.capitalizeOnly()}\n${jobConfirmList[index].status}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                ),
                trailing: IconButton(
                  onPressed: () => moveToLoadDialogBox(
                      jobConfirmList[index].palletActivityId),
                  icon: const Icon(
                    FluentIcons.clipboard_arrow_right_24_filled,
                    size: 40,
                  ),
                ),
              )),
        );

    // pallet loading and loaded content tab
    Widget jobLoadsContent(index) => Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                side: BorderSide(width: 0.3, color: Colors.grey.shade600)),
            elevation: 5,
            color: customCardColorStatus('Loading To Truck'),
            child: ListTile(
                isThreeLine: true,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => PalletDetailsView(
                            palletActivityId:
                                jobLoadingList[index].palletActivityId)),
                  );
                },
                title: Text(
                  jobLoadingList[index].palletNo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "${jobLoadingList[index].openPalletLocation.capitalizeOnly()}\n${jobLoadingList[index].status}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => PalletSignature(
                                  palletNo: jobLoadingList[index].palletNo,
                                  palletActivityId:
                                      jobLoadingList[index].palletActivityId,
                                )))
                        .then((_) {
                      setState(() {});
                    });
                  },
                  icon: const Icon(
                    FluentIcons.clipboard_more_24_filled,
                    size: 40,
                  ),
                )),
          ),
        );

    // Create Tab categories; Assigned, Confirmed, Loading
    Widget palletCategories() {
      Widget appBarTitle = const Text(
        "Today's Job List",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      );

      return DefaultTabController(
        initialIndex: 0,
        length: 2,
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
                Tab(
                  child: Text(
                    'Loading Pallet',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Consumer<PalletNotifier>(builder: ((context, value, child) {
            List<Pallet> allJobs =
                value.pallets.entries.map((e) => e.value).toList();

            jobAssignedList = List.empty(growable: true);
            jobConfirmList = List.empty(growable: true);
            jobLoadingList = List.empty(growable: true);

            for (var i = 0; i < allJobs.length; i++) {
              if (allJobs[i].status == "Load Job Pending") {
                jobAssignedList.add(allJobs[i]);
              } else if (allJobs[i].status == "Load Job Confirmed") {
                jobConfirmList.add(allJobs[i]);
              } else if (allJobs[i].status == "Loading To Truck") {
                jobLoadingList.add(allJobs[i]);
              }
            }

            return TabBarView(
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
                    child: jobConfirmList.isEmpty
                        ? const Center(child: Text('No job confirm for today'))
                        : ListView.builder(
                            itemCount: jobConfirmList.length,
                            itemBuilder: ((context, index) =>
                                confirmJobContent(index))),
                  ),
                ),
                Container(
                  color: AppColor().milkWhite,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: jobLoadingList.isEmpty
                        ? const Center(child: Text('No loading job for today'))
                        : ListView.builder(
                            itemCount: jobLoadingList.length,
                            itemBuilder: ((context, index) =>
                                jobLoadsContent(index))),
                  ),
                ),
              ],
            );
          })),
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

  moveToConfirmDialogBox(palletActivityId) => showDialog(
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
              'Confirm to accept this assigned job?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
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
                onPressed: () {
                  Navigator.of(context).pop();
                  confirmJob(palletActivityId);
                },
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
      );

  moveToLoadDialogBox(palletActivityId) => showDialog(
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
              'Confirm to load this pallet to truck?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
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
                onPressed: () {
                  Navigator.of(context).pop();
                  loadJob(palletActivityId);
                },
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
      );
}
