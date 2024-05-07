import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';

class JobAssignView extends StatefulWidget {
  const JobAssignView({super.key});

  @override
  State<JobAssignView> createState() => _JobAssignViewState();
}

class _JobAssignViewState extends State<JobAssignView>
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
                  'Job Assign',
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
              child: const Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child: Center(
                    child: Text('No job assign for today'),
                  )),
            ),
            Container(
              color: AppColor().milkWhite,
              child: const Padding(
                  padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                  child: Center(
                    child: Text('No confirm job for today'),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
