import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/global_utils.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/utils/storage_utils.dart';
import 'package:store_management_system/view/login/login_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  String displayName = '';
  int userType = -1;

  @override
  void initState() {
    super.initState();
    _getDisplayName();
    _getUserType();
  }

  _getDisplayName() async {
    displayName = await Storage.instance.getDisplayName();
    setState(() {});
  }

  _getUserType() async {
    userType = await Storage.instance.getUserType();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColor().milkWhite,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () => _logout(),
              icon: const Icon(
                FluentIcons.sign_out_24_filled,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColor().milkWhite,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: ListBody(
                children: [
                  Text(
                    "Manage Your Account",
                    style: TextStyle(
                      color: AppColor().yaleBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    leading: const Icon(
                      Icons.account_circle_outlined,
                      size: 25,
                    ),
                    title: Text(
                      "Username",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    subtitle: Text(
                      displayName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    leading: const Icon(
                      Icons.manage_accounts_outlined,
                      size: 25,
                    ),
                    title: Text(
                      "Role",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    subtitle: Text(
                      getUserType(userType),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Application Info",
                    style: TextStyle(
                      color: AppColor().yaleBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  const ListTile(
                    visualDensity: VisualDensity(vertical: -4),
                    leading: Icon(
                      Icons.info_outline_rounded,
                      size: 25,
                    ),
                    title: Text(
                      "Version 1.0.0",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _logout() async {
    Global.instance.isLoggedIn = false;

    await ApiServices.user.logout();
    Storage.instance.removeData();

    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginView()),
        (route) => false,
      );
    }
  }
}
