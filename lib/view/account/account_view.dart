import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/main_utils.dart';
import 'package:store_management_system/utils/storage_utils.dart';
import 'package:store_management_system/view/account/user_profile_view.dart';
import 'package:store_management_system/view/login/login_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25.0),
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
                      Icons.manage_accounts_outlined,
                      size: 25,
                    ),
                    title: const Text(
                      "Account Information",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.of(context).push(SlideRoute(
                          page: const UserProfile(), toRight: false));
                    },
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Need Help?",
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
                      Icons.question_mark_outlined,
                      size: 25,
                    ),
                    title: const Text(
                      "FAQ",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                    onTap: () {},
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    leading: const Icon(
                      Icons.sticky_note_2_sharp,
                      size: 25,
                    ),
                    title: const Text(
                      "Application Manual",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                    onTap: () {},
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    leading: const Icon(
                      Icons.question_answer_outlined,
                      size: 25,
                    ),
                    title: const Text(
                      "Feedback",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                    onTap: () {},
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
                  ListTile(
                    visualDensity: const VisualDensity(vertical: -4),
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      size: 25,
                    ),
                    title: const Text(
                      "Version Info",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                    onTap: () {},
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
