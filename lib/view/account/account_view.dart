import 'package:flutter/material.dart';
import 'package:store_management_system/utils/main_utils.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('My Account'),
      backgroundColor: const Color.fromRGBO(245, 254, 253, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: ListBody(
                children: [
                  const Text(
                    "Manage Your Account",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 102, 178, 1),
                      fontSize: 14,
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
                        fontSize: 13,
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
                      Icons.manage_accounts_outlined,
                      size: 25,
                    ),
                    title: const Text(
                      "Account Management",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
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
                  const Text(
                    "Need Help?",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 102, 178, 1),
                      fontSize: 14,
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
                        fontSize: 13,
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
                        fontSize: 13,
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
                        fontSize: 13,
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
                  const Text(
                    "Application Info",
                    style: TextStyle(
                      color: Color.fromRGBO(0, 102, 178, 1),
                      fontSize: 14,
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
                        fontSize: 13,
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
                      Icons.policy_outlined,
                      size: 25,
                    ),
                    title: const Text(
                      "Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
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
}
