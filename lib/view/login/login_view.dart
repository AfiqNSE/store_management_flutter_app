import 'package:flutter/material.dart';
import 'package:store_management_system/models/color_model.dart';
import 'package:flutter/services.dart';
import 'package:store_management_system/services/api_services.dart';
import 'package:store_management_system/utils/storage_utils.dart';
import 'package:store_management_system/view/navigation/navigation_view.dart';

// TODO: add autofills for ios

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    autofill();
    checklogin();
  }

  autofill() async {
    username.text = await Storage.instance.username;
    password.text = await Storage.instance.password;
  }

  checklogin() async {
    String guid = await Storage.instance.getGuid();
    String token = await Storage.instance.getRefreshToken();

    if (guid == "" || token == "") {
      debugPrint("[Login] User is NOT logged in: GUID or token does not exist");
      setState(() {
        loading = false;
      });

      return;
    }

    bool loggedin = false;
    try {
      loggedin = await ApiServices.user.authorized();
    } catch (e) {
      debugPrint("Error: [Login] ${e.toString()}");
    }

    if (!loggedin) {
      debugPrint("[Login] User is NOT logged in");
      setState(() {
        loading = false;
      });

      return;
    }

    debugPrint("[Login] User is logged in");
    setState(() {
      loading = false;
    });

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const NavigationTabView()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Background image with custom style
    Widget backgroundImage = SizedBox(
      height: 240,
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.elliptical(300, 70),
        ),
        child: Image.asset(
          'assets/images/login-background.jpeg',
          scale: 1,
          fit: BoxFit.cover,
        ),
      ),
    );

    // Login form
    Form loginForm = Form(
      key: _formKey,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(35, 40, 35, 0),
          child: AutofillGroup(
            child: Column(children: [
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
              ),
              const Text(
                'Login to your account',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: username,
                style: const TextStyle(fontSize: 14),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: AppColor().blueZodiac,
                    fontWeight: FontWeight.w600,
                  ),
                  hintText: 'Enter your username',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor().blueZodiac,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                autocorrect: false,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(" "))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                enabled: !loading,
                autofillHints: const [AutofillHints.username],
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: password,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    color: AppColor().blueZodiac,
                    fontWeight: FontWeight.w600,
                  ),
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor().blueZodiac,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                enabled: !loading,
                autofillHints: const [AutofillHints.password],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onFieldSubmitted: (value) => submit(),
              ),
            ]),
          ),
        ),
      ),
    );

    // Bottom component: Login button, app name & version
    Widget bottomComponent = Padding(
      padding: const EdgeInsets.fromLTRB(35, 0, 35, 15),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(120, 50),
                backgroundColor: AppColor().blueZodiac,
                disabledBackgroundColor: const Color.fromRGBO(31, 48, 94, .5),
                elevation: 3,
              ),
              onPressed: (loading) ? null : () => submit(),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Store Management Application",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            "v1.0.0",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
        ]),
      ),
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: AppColor().milkWhite,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Company image/logo
                backgroundImage,
                // Login Form
                loginForm,
                // Bottom Component
                bottomComponent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submit() {
    ScaffoldMessengerState sm = ScaffoldMessenger.of(context);
    setState(() {
      loading = true;
    });

    if (!_formKey.currentState!.validate()) {
      sm.clearSnackBars();
      sm
          .showSnackBar(const SnackBar(
            content: Text("Make sure all fields are not empty"),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ))
          .closed
          .then((value) => setState(() => loading = false));

      return;
    }

    sm.clearSnackBars();
    sm.showSnackBar(const SnackBar(
      content: Text("Logging in..."),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 2),
    ));

    login().then((value) {
      // If return value is greater than 0 means there is an error
      if (value > 1) {
        sm.clearSnackBars();
        sm
            .showSnackBar(const SnackBar(
              content: Text("Server error, please try again later"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ))
            .closed
            .then((value) => setState(() => loading = false));

        return;
      } else if (value == 1) {
        sm.clearSnackBars();
        sm
            .showSnackBar(const SnackBar(
              content: Text("Wrong username or password"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ))
            .closed
            .then((value) => setState(() => loading = false));

        return;
      }

      sm.clearSnackBars();
      sm
          .showSnackBar(const SnackBar(
            content: Text("Logged in"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ))
          .closed
          .then(
        (value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationTabView()),
            (route) => false,
          );
        },
      );
    });
  }

  Future<int> login() async {
    Map<dynamic, dynamic> res = await ApiServices.user.login(
      username.text,
      password.text,
    );

    if (res.containsKey("err")) {
      return res["err"];
    }

    TextInput.finishAutofillContext();
    Storage.instance.setGuid(res["user"]["guid"]);
    Storage.instance.setUsername(username.text);
    Storage.instance.setPassword(password.text);
    Storage.instance.setDisplayName(res["user"]["displayName"]);
    Storage.instance.setAccessToken(res["token"]["access"]);
    Storage.instance.setRefreshToken(res["token"]["refresh"]);

    return 0;
  }
}
