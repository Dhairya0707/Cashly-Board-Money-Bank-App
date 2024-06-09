import 'package:board_money/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign Up",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Gap(40),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Enter Your Details",
                        textScaler: TextScaler.linear(1.5),
                        style: TextStyle(fontWeight: FontWeight.w800),
                      )
                    ],
                  ),
                ),
                const Gap(40),
                value.textinput(value.username, "Enter Your Username",
                    Icons.star, false, context, true),
                const Gap(40),
                value.password(value.pass, "Enter Your Password", context),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            value.signup(context);
          },
          label: const Text("Sign Up"),
          icon: value.isloading
              ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator())
              : const Icon(Icons.arrow_forward_rounded),
        ),
      );
    });
  }
}
