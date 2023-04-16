import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../Shared/constant.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/input_text_field.dart';
import '../../Widgets/text_widget.dart';
import '../../Widgets/widget.dart';
import '../home_page.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();

  String fullName = "";
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
                  color: Theme.of(context).primaryColor),
            )
          : SafeArea(
              child: SingleChildScrollView(
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
                          title: "Create you account now to chat and explore.",
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                        const Image(
                          image: AssetImage("assets/register.png"),
                        ),
                        TextFormFieldWidget(
                          label: "Full Name",
                          isObscure: false,
                          prefixIcon: Icons.person,
                          onChange: (value) {
                            setState(() {
                              fullName = value!;
                            });
                          },
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Name cannot be empty";
                            }
                          },
                        ),
                        SizedBox(
                          height: Constant().defaultPadding / 2,
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
                          text: "Register",
                          onPress: () {
                            register();
                          },
                        ),
                        SizedBox(
                          height: Constant().defaultPadding / 2,
                        ),
                        Text.rich(
                          TextSpan(
                              text: "Already have an account? ",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                    text: "Login now",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextScreen(context, const LoginPage());
                                      }),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authServices
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserName(fullName);
          await HelperFunction.saveUserEmail(email);
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
