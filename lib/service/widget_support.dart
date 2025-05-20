import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle headlineTextFieldStyle() {
    return TextStyle(
        color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold);
  }

  static TextStyle simpleTextFieldStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 18.0,
    );
  }

  static TextStyle whiteTextFieldStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle boldTextStyle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle boldBhiteTextFieldStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle signupTextFieldStyle() {
    return TextStyle(
      color: const Color.fromARGB(174, 0, 0, 0),
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );
  }
}
