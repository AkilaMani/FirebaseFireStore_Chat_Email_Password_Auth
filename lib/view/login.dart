import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/helper/helperfunctions.dart';
import 'package:firebase_chat/services/auth.dart';
import 'package:firebase_chat/services/database.dart';
import 'package:firebase_chat/values/colors.dart';
import 'package:firebase_chat/values/strings.dart';
import 'package:firebase_chat/widget/widget.dart';
import 'package:flutter/material.dart';

import 'chatroom.dart';
import 'forget_password.dart';

class Login extends StatefulWidget {
  final Function toggleView;

  Login(this.toggleView);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  AuthService authService = AuthService();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  login() async {
    print(':::::::: ${emailEditingController.text}');
    print(':::::::: ${passwordEditingController.text}');

    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text.toString().trim(),
              passwordEditingController.text.toString().trim())
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseMethods()
              .getUserInfo(emailEditingController.text.toString().trim());

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.docs[0]['userName']);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.docs[0]['userEmail']);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context, loginScreenTitle),
      body: isLoading
          ? Container(
              child: const Center(child: CircularProgressIndicator()),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Spacer(),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Please Enter Correct Email";
                          },
                          controller: emailEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("email"),
                        ),
                        TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val!.length >= 6
                                ? null
                                : "Enter Password 6+ characters";
                          },
                          style: simpleTextStyle(),
                          controller: passwordEditingController,
                          decoration: textFieldInputDecoration("password"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              "Forgot Password?",
                              style: simpleTextStyle(),
                            )),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      login();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            colors: [indigoAccent100, indigoAccent400],
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Login",
                        style: biggerTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have account? ",
                        style: simpleTextStyle(),
                      ),
                      InkWell(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          "Register now",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
    );
  }
}
