import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/components/pallet_signature_component.dart';
import 'package:store_management_system/components/search_components.dart';
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

  TextEditingController searchController = TextEditingController();

  late List<Pallet> jobAssignedList;
  late List<Pallet> jobConfirmList;
  late List<Pallet> jobLoadingList;

  //Store only palletNo for search functionality
  late List<String> allPalletNoList;

  late TabController _tabController;
  bool isAccess = true;
  bool searchMode = false;
  bool isLoading = false;

  late String _searchValue = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Provider.of<PalletNotifier>(context, listen: false).initialize();
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
        );
        return;
      }
      customShowToast(
        context,
        "Job confirmation successful.",
        Colors.blue.shade300,
      );
      setState(() {});

      Provider.of<PalletNotifier>(context, listen: false)
          .confirm(palletActivityId);

      Provider.of<PalletNotifier>(context, listen: false).initialize();
    }
  }

  loadJob(int palletActivityId) async {
    bool res = await ApiServices.pallet.load(palletActivityId);
    if (mounted) {
      if (res != true) {
        customShowToast(
          context,
          "Failed to load the pallet onto the truck. Please try again",
          Colors.red.shade300,
        );
        return;
      }
      customShowToast(
        context,
        "Loading this pallet onto the truck.",
        Colors.blue.shade300,
      );

      setState(() {});

      Provider.of<PalletNotifier>(context, listen: false)
          .load(palletActivityId);

      Provider.of<PalletNotifier>(context, listen: false).initialize();
    }
  }

  searchJobs(List<String> palletNoList, String value) {
    if (palletNoList.contains(value)) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PalletDetailsView(palletNo: value)));
    } else {
      customShowToast(context, "No Job Found", Colors.red.shade300);
    }
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PalletSignature(
                              palletNo: jobLoadingList[index].palletNo,
                              palletActivityId:
                                  jobLoadingList[index].palletActivityId,
                            )));
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

      Widget search = PalletSearch(
        activePalletOnly: true,
        padding: const EdgeInsets.only(left: NavigationToolbar.kMiddleSpacing),
        controller: searchController,
        onSearch: (value) async {
          _searchValue = value;
          await searchJobs(allPalletNoList, _searchValue.toUpperCase());
        },
      );

      Widget createTab(text, value) => Tab(
            child: Stack(
              children: [
                Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: value != 0 ? 11 : 13),
                  ),
                ),
                value != 0
                    ? Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade300,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          );

      return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: AppColor().milkWhite,
                  title: searchMode ? search : appBarTitle,
                  pinned: true,
                  floating: true,
                  forceElevated: innerBoxIsScrolled,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: (!searchMode)
                          ? IconButton(
                              onPressed: () =>
                                  setState(() => searchMode = true),
                              icon: const Icon(FluentIcons.search_24_filled,
                                  size: 28),
                            )
                          : TextButton(
                              onPressed: () =>
                                  setState(() => searchMode = false),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor().yaleBlue,
                                ),
                              ),
                            ),
                    ),
                  ],
                  bottom: TabBar(
                    labelColor: AppColor().blueZodiac,
                    indicatorColor: AppColor().blueZodiac,
                    controller: _tabController,
                    tabs: <Widget>[
                      Consumer<PalletNotifier>(
                          builder: (context, value, child) {
                        return createTab('Job Assigned', value.assignedJob);
                      }),
                      Consumer<PalletNotifier>(
                          builder: (context, value, child) {
                        return createTab('Confirm Job', value.confirmJob);
                      }),
                      Consumer<PalletNotifier>(
                          builder: (context, value, child) {
                        return createTab('Loading Pallet', value.loadingJob);
                      }),
                    ],
                  ),
                ),
              ];
            },
            body: Consumer<PalletNotifier>(
              builder: ((context, value, child) {
                List<Pallet> allJobs =
                    value.pallets.entries.map((e) => e.value).toList();

                jobAssignedList = List.empty(growable: true);
                jobConfirmList = List.empty(growable: true);
                jobLoadingList = List.empty(growable: true);
                allPalletNoList = List.empty(growable: true);

                for (var i = 0; i < allJobs.length; i++) {
                  if (allJobs[i].status == "Load Job Pending") {
                    jobAssignedList.add(allJobs[i]);
                  } else if (allJobs[i].status == "Load Job Confirmed") {
                    jobConfirmList.add(allJobs[i]);
                  } else if (allJobs[i].status == "Loading To Truck") {
                    jobLoadingList.add(allJobs[i]);
                  }

                  //Only get the palletNo
                  allPalletNoList.add(allJobs[i].palletNo);
                }

                if (isLoading == true) {
                  Container(
                    color: const Color.fromRGBO(255, 255, 255, .8),
                    child: const Center(
                        child: CircularProgressIndicator.adaptive()),
                  );
                }

                return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      Container(
                        color: AppColor().milkWhite,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: jobAssignedList.isEmpty
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/job-done-background.png',
                                      scale: 2.3,
                                    ),
                                    const SizedBox(height: 3),
                                    const Text('No assigned job for today.'),
                                  ],
                                ))
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
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/job-done-background.png',
                                      scale: 2.3,
                                    ),
                                    const SizedBox(height: 3),
                                    const Text('No confirm job for today.'),
                                  ],
                                ))
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
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/job-done-background.png',
                                      scale: 2.3,
                                    ),
                                    const SizedBox(height: 3),
                                    const Text('No loading job for today.'),
                                  ],
                                ))
                              : ListView.builder(
                                  itemCount: jobLoadingList.length,
                                  itemBuilder: ((context, index) =>
                                      jobLoadsContent(index))),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
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
