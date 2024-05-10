import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/utils/main_utils.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Profile'),
      backgroundColor: AppColor().milkWhite,
      body: const Center(
        child: Text('User Profile Page'),
      ),
    );
  }
}
