import 'package:flutter/material.dart';

class Constant {
  static String apiKey = "AIzaSyAGxMyGLc5dAZyqyMSj12WMrGRYKJ_XKXY";
  static String authDomain = "chatappflutter-150b4.firebaseapp.com";
  static String projectId = "chatappflutter-150b4";
  static String storageBucket = "chatappflutter-150b4.appspot.com";
  static String messagingSenderId = "1008060888838";
  static String appId = "1:1008060888838:web:f155782def4b796c70d087";

  final primaryColor = const Color(0xFF443C68);
  // final primaryColor = const Color(0xFFee7b64);

  final double defaultPadding = 20.0;

  // String manipulation
  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }
}
