import 'package:firebase_chat/helper/authenticate.dart';
import 'package:firebase_chat/values/colors.dart';
import 'package:firebase_chat/view/chatroom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'helper/helperfunctions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

   bool userIsLoggedIn = false;


  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    if(userIsLoggedIn){
      await HelperFunctions.getUserLoggedInSharedPreference().then((value){
        setState(() {
          userIsLoggedIn  = value!;
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff145C9E),
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        accentColor: Color(0xff007EF4),
        fontFamily: "OverpassRegular",
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn != null ?  userIsLoggedIn ? ChatRoom() : Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}
