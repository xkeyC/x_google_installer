import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:x_google_installer/ui/splash_page.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SplashPage());
}
