import 'package:board_money/screen/Home_page.dart';
import 'package:board_money/screen/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  var box = Hive.box("bank");
  @override
  Widget build(BuildContext context) {
    if (box.get("isLogin") ?? false) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
