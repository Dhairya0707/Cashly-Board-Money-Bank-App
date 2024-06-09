// ignore_for_file: file_names

import 'package:board_money/provider/login_provider.dart';
import 'package:board_money/screen/Signup_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, value, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Get Started',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        fit: StackFit.loose,
                        children: [
                          RandomAvatar(
                            value.svg,
                          ),
                          IconButton(
                              onPressed: () {
                                value.chnageicon();
                              },
                              icon: const Icon(Icons.refresh))
                        ],
                      ),
                    ],
                  ),
                  const Gap(25),
                  value.textinput(value.name, "Enter Display Name",
                      Icons.person, true, context, false),
                  const Gap(25),
                  value.textinput(value.username, "Enter Username", Icons.star,
                      false, context, true),
                  const Gap(25),
                  value.textinput(value.email, "Enter Email Address",
                      Icons.mail_rounded, false, context, false),
                  const Gap(25),
                  value.password(value.pass, "Create Password", context),
                  const Gap(30),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: const Text("Already have account ?"))
                    ],
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              value.loginapp(context);
            },
            label: const Text("Login"),
            icon: const Icon(
              Icons.arrow_forward,
            ),
          ));
    });
  }
}
