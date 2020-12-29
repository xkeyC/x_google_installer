import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_google_installer/ui/splash_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(SplashPage());
}
