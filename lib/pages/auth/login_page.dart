import 'package:chat_app/pages/auth/register_page.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/shared/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../Widgets/custom_button.dart';
import '../../Widgets/input_text_field.dart';
import '../../Widgets/text_widget.dart';
import '../../Widgets/widget.dart';
import '../../helper/helper_function.dart';
import '../../services/database_services.dart';
import '../home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const TextWidget(
                        title: "Groupie",
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: Constant().defaultPadding / 2,
                      ),
                      const TextWidget(
                        title: "Login now to see what they are talking!",
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                      const Image(
                        image: AssetImage("assets/login.png"),
                      ),
                      TextFormFieldWidget(
                        label: "Email",
                        isObscure: false,
                        prefixIcon: Icons.email,
                        onChange: (value) {
                          setState(() {
                            email = value!;
                          });
                        },
                        validator: (value) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!)
                              ? null
                              : "Please enter a valid email";
                        },
                      ),
                      SizedBox(
                        height: Constant().defaultPadding / 2,
                      ),
                      TextFormFieldWidget(
                        label: "Password",
                        isObscure: true,
                        prefixIcon: Icons.lock,
                        onChange: (value) {
                          setState(() {
                            password = value!;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 8) {
                            return "Password must be at least 8 characters";
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: Constant().defaultPadding,
                      ),
                      CustomButton(
                        width: width,
                        text: "Sign In",
                        onPress: () {
                          login();
                        },
                      ),
                      SizedBox(
                        height: Constant().defaultPadding / 2,
                      ),
                      Text.rich(
                        TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                  text: "Register here",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      nextScreen(context, const RegisterPage());
                                    }),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices
          .loginWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot querySnapshot = await DatabaseServices(
                  uid: FirebaseAuth.instance.currentUser!.uid)
              .gettingUserData(email);
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmail(email);
          await HelperFunction.saveUserName(querySnapshot.docs[0]['fullName']);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
