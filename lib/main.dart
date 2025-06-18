import 'package:flutter/material.dart';
import 'package:sisfo_mobile_brian/screens/landing_page.dart';
import 'package:sisfo_mobile_brian/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sisfo_mobile_brian/screens/main_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
}

class MyApp extends StatelessWidget {
   final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home:isLoggedIn ? const MainPage() : const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}