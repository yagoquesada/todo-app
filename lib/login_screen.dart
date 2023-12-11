import 'dart:convert';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/config.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/register_screen.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:todo_app/utils/helper_functions.dart';
import 'package:todo_app/utils/snackbar.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TEXTFIELDS CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isNotValidate = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var reqBody = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      var response = await http.post(
        Uri.parse(login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(reqBody),
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefs.setString('token', myToken);

        // ignore: use_build_context_synchronously
        YHelperFunctions.navigateToScreen(context, HomeScreen(token: myToken));
      } else {
        getSnackBar("Oh Snap!", "Error signing up the user, try again!", true);
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                YColors.primary,
                YColors.secondary,
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // ************** LOGO SVG **************
                  SvgPicture.asset(
                    "assets/logo/logo_todo_black.svg",
                    height: MediaQuery.of(context).size.height * 0.2,
                    colorFilter: const ColorFilter.mode(YColors.offwhite, BlendMode.srcIn),
                  ),
                  const Spacer(),
                  // ************** TITLE: LOGIN **************
                  Text(
                    "Login",
                    style: GoogleFonts.majorMonoDisplay(
                      fontSize: 36,
                      color: YColors.offwhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  YHelperFunctions.addVerticalSpace(28),
                  // ************** TEXTFIELD EMAIL **************
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: YColors.offwhite,
                      errorStyle: const TextStyle(color: YColors.offwhite),
                      errorText: _isNotValidate ? "Enter a valid email" : null,
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: YColors.error),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      hintText: "Email",
                    ),
                  ),
                  YHelperFunctions.addVerticalSpace(18),
                  // ************** TEXTFIELD PASSWORD **************
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: YColors.offwhite,
                      errorStyle: const TextStyle(color: YColors.offwhite),
                      errorText: _isNotValidate ? "Enter a valid password" : null,
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: YColors.error),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      hintText: "Password",
                    ),
                  ),
                  YHelperFunctions.addVerticalSpace(16),
                  // ************** FORGOT PASSWORD? **************
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: "Forgot password?",
                        style: const TextStyle(decoration: TextDecoration.underline, fontSize: 16),
                        mouseCursor: MaterialStateMouseCursor.clickable,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            log("Forgot Password");
                          },
                      ),
                    ),
                  ),
                  YHelperFunctions.addVerticalSpace(25),
                  // ************** LOGIN BUTTON **************
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => loginUser(),
                      style: const ButtonStyle(
                        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 18)),
                        backgroundColor: MaterialStatePropertyAll(YColors.accent),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      child: const Text("Login"),
                    ),
                  ),
                  YHelperFunctions.addVerticalSpace(25),
                  //  ************** Don't have an account yet? SIGN UP! **************
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16),
                      children: [
                        const TextSpan(text: "Don't have an account yet? "),
                        TextSpan(
                          text: "SIGN UP!",
                          style: const TextStyle(decoration: TextDecoration.underline),
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              YHelperFunctions.navigateToScreen(context, const RegisterScreen());
                            },
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
