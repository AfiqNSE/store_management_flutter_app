import 'package:flutter/material.dart';
import 'package:store_management_system/view/navigation/navigation_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(252, 252, 252, 1),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Company image/logo
              backgroundImage(),
              // Login Form
              loginForm(),
              // Bottom Component
              bottomLogin(),
            ],
          ),
        ),
      ),
    );
  }

  // Background image with custom style
  Widget backgroundImage() => Container(
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

  Form loginForm() => Form(
        key: _formKey,
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 40, 35, 0),
            child: Column(
              children: [
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 35,
                    color: Color.fromRGBO(40, 40, 43, 1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'Login to your account',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromRGBO(40, 40, 43, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),
                TextFormField(
                  controller: username,
                  style: const TextStyle(
                    color: Color.fromRGBO(40, 40, 43, 1),
                    fontSize: 14,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(31, 48, 94, 1),
                      fontWeight: FontWeight.w600,
                    ),
                    hintText: 'Enter your username',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(31, 48, 94, 1),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  autocorrect: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: password,
                  style: const TextStyle(
                    color: Color.fromRGBO(40, 40, 43, 1),
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(31, 48, 94, 1),
                      fontWeight: FontWeight.w600,
                    ),
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(31, 48, 94, 1),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      );

  // Bottom component: Login button, app name & version
  Widget bottomLogin() => Padding(
        padding: const EdgeInsets.fromLTRB(35, 0, 35, 15),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all(const Size(120, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(31, 48, 94, 1),
                    ),
                    elevation: MaterialStateProperty.all(3),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Processing Data')),
                      // );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NavigationTabView()),
                        (route) => false,
                      );
                    }
                  },
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
            ],
          ),
        ),
      );
}
