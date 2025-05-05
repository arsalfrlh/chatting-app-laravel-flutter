import 'package:chatting/pages/home_page.dart';
import 'package:chatting/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final key = await SharedPreferences.getInstance();
  runApp(MyApp(statusLogin: key.getBool('statusLogin') ?? false,));
}

class MyApp extends StatelessWidget {
  MyApp({required this.statusLogin});
  bool statusLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatting',
      home: statusLogin
      ? HomePage()
      : LoginPage(),
    );
  }
}
