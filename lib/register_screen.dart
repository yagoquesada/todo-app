import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/config.dart';
import 'package:todo_app/login_screen.dart';
import 'package:todo_app/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/utils/helper_functions.dart';
import 'package:todo_app/utils/snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // TEXTFIELDS CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isNotValidate = false;

  void registerUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var regBody = {
        'email': emailController.text,
        'password': passwordController.text,
      };

      var response = await http.post(
        Uri.parse(registration),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(regBody),
      );

      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status']) {
        // ignore: use_build_context_synchronously
        YHelperFunctions.navigateToScreen(context, const LoginScreen());
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
                  // ************** TITLE: REGISTER **************
                  Text(
                    "Register",
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
                  YHelperFunctions.addVerticalSpace(25),
                  // ************** REGISTER BUTTON **************
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => registerUser(),
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
                      child: const Text("Register"),
                    ),
                  ),
                  YHelperFunctions.addVerticalSpace(25),
                  //  ************** Already have an account? SIGN IN! **************
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 16),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text: "SIGN IN!",
                          style: const TextStyle(decoration: TextDecoration.underline),
                          mouseCursor: MaterialStateMouseCursor.clickable,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              YHelperFunctions.navigateToScreen(context, const LoginScreen());
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
