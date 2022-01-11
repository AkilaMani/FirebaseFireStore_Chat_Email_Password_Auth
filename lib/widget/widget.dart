import 'package:firebase_chat/values/colors.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBarMain(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: titleTextStyle(),
    ),
    backgroundColor: indigoAccent100,
    centerTitle: true,
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white54),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)));
}

TextStyle simpleTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}

TextStyle titleTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 20);
}
