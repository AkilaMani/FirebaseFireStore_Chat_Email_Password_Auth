import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat/helper/helperfunctions.dart';
import 'package:firebase_chat/services/auth.dart';
import 'package:firebase_chat/services/database.dart';
import 'package:firebase_chat/values/colors.dart';
import 'package:firebase_chat/values/strings.dart';
import 'package:firebase_chat/widget/widget.dart';
import 'package:flutter/material.dart';

import 'chatroom.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register(this.toggleView);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController usernameEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  AuthService authService = AuthService();
  DatabaseMethods databaseMethods = DatabaseMethods();

  register() async {
    print(':::::::: ${emailEditingController.text}');
    print(':::::::: ${passwordEditingController.text}');
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signUpWithEmailAndPassword(
              emailEditingController.text.toString().trim(),
              passwordEditingController.text.toString().trim())
          .then((result) async {
        print(':::::::: $result');

        if (result != null) {
          Map<String, String> userDataMap = {
            "userName": usernameEditingController.text,
            "userEmail": emailEditingController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              usernameEditingController.text.toString().trim(),);
          HelperFunctions.saveUserEmailSharedPreference(
              emailEditingController.text.toString().trim(),);

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
      appBar: appBarMain(context, registerScreenTitle),
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
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
                          style: simpleTextStyle(),
                          controller: usernameEditingController,
                          validator: (val) {
                            return val!.isEmpty || val.length < 3
                                ? "Enter Username 3+ characters"
                                : null;
                          },
                          decoration: textFieldInputDecoration("username"),
                        ),
                        TextFormField(
                          controller: emailEditingController,
                          style: simpleTextStyle(),
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Enter correct email";
                          },
                          decoration: textFieldInputDecoration("email"),
                        ),
                        TextFormField(
                          obscureText: true,
                          style: simpleTextStyle(),
                          decoration: textFieldInputDecoration("password"),
                          controller: passwordEditingController,
                          validator: (val) {
                            return val!.length < 6
                                ? "Enter Password 6+ characters"
                                : null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      register();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: indigoAccent100,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Register",
                        style: biggerTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: simpleTextStyle(),
                      ),
                      InkWell(
                        onTap: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          "Login now",
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
