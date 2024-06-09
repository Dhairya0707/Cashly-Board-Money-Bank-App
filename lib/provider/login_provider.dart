import 'package:board_money/utils/gate/connection_gate.dart';
import 'package:board_money/utils/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:random_avatar/random_avatar.dart';

class LoginProvider extends ChangeNotifier {
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool pas = true;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final firebasemsg = FirebaseMessaging.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  var box = Hive.box("bank");
  String svg = RandomAvatarString(
    DateTime.now().toIso8601String(),
    trBackground: false,
  );

  void chnageicon() {
    svg = RandomAvatarString(
      DateTime.now().toIso8601String(),
      trBackground: false,
    );
    notifyListeners();
  }

  void loginapp(context) async {
    String names = name.text;
    String usernames = username.text;
    String emails = email.text;
    String passwords = pass.text;
    try {
      check(() async {
        DocumentSnapshot docSnapshot =
            await firestore.collection("users").doc(usernames).get();
        if (docSnapshot.data() == null) {
          local(names, usernames, emails, passwords);

          await firestore.collection("users").doc(usernames).set({
            "name": names,
            "username": usernames,
            "email": emails,
            "avatar": svg,
            "password": passwords,
            "fcmtoken": await firebasemsg.getToken(),
            "time": DateTime.now(),
            "search": generateSubstrings(usernames),
          });
          box.put("isLogin", true);
          GeneralProvider.showsnackbar(context, "Login Successful");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ConnectionGate()),
              (route) => false);
          //, txt)
          notifyListeners();
        } else {
          GeneralProvider.showsnackbar(context, "Username Already Exists");
        }
      }, context);
    } catch (e) {
      GeneralProvider.showsnackbar(context, e.toString());
    }
  }

  void local(names, usernames, emails, passwords) async {
    box.put("name", names);
    box.put("username", usernames);
    box.put("email", emails);
    box.put("avatar", svg);
    box.put("passowrd", passwords);
    box.put("fcmtoken", await firebasemsg.getToken() ?? "not given");
  }

  bool isValidEmail(String email) {
    final emailPattern = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}$");
    return emailPattern.hasMatch(email);
  }

  List<String> generateSubstrings(String name) {
    List<String> substrings = [];
    for (int i = 1; i <= name.length; i++) {
      for (int j = 0; j <= name.length - i; j++) {
        substrings.add(name.substring(j, j + i));
      }
    }
    return substrings;
  }

  void check(Function() after, context) {
    if (name.text.isNotEmpty) {
      if (username.text.isNotEmpty) {
        if (email.text.isNotEmpty && isValidEmail(email.text)) {
          if (pass.text.isNotEmpty && pass.text.length >= 4) {
            after();
          } else {
            GeneralProvider.showsnackbar(
                context, "Fill Password , Minimum 8 Character");
          }
          //all thing here
        } else {
          GeneralProvider.showsnackbar(context, "Fill Email Properly");
        }
      } else {
        GeneralProvider.showsnackbar(context, "Fill Username");
      }
    } else {
      GeneralProvider.showsnackbar(context, "Fill Display Name");
    }
  }

  Widget textinput(TextEditingController controller, String hint, IconData icon,
      bool isObscure, context, bool isusername) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          isusername
              ? TextInputFormatter.withFunction(
                  (oldValue, newValue) {
                    if (newValue.text.isNotEmpty) {
                      return TextEditingValue(
                        text: newValue.text.toLowerCase(),
                        selection: newValue.selection,
                      );
                    }
                    return newValue;
                  },
                )
              : TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue;
                }),
          isObscure
              ? TextInputFormatter.withFunction(
                  (oldValue, newValue) {
                    if (newValue.text.isNotEmpty) {
                      return TextEditingValue(
                        text: newValue.text.substring(0, 1).toUpperCase() +
                            newValue.text.substring(1).toLowerCase(),
                        selection: newValue.selection,
                      );
                    }
                    return newValue;
                  },
                )
              : TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue;
                }),
        ],
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            filled: true,
            hintText: hint,
            // fillColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
            hintStyle: const TextStyle(fontFamily: "Jost"),
            prefixIcon: isusername
                ? const Padding(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    child: Text(
                      '#',
                      style: TextStyle(fontWeight: FontWeight.w900),
                      textScaler: TextScaler.linear(1.4),
                    ),
                  )
                : Icon(icon)),
      ),
    );
  }

  Widget password(TextEditingController controller, String hint, context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: TextField(
        controller: controller,
        obscureText: pas,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
            filled: true,
            suffixIcon: pas
                ? IconButton(
                    onPressed: () {
                      pas = false;
                      notifyListeners();
                    },
                    icon: const Icon(Icons.visibility_off))
                : IconButton(
                    onPressed: () {
                      pas = true;
                      notifyListeners();
                    },
                    icon: const Icon(Icons.visibility)),
            hintText: hint,
            // fillColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
            hintStyle: const TextStyle(fontFamily: "Jost"),
            prefixIcon: const Icon(Icons.password_rounded)),
      ),
    );
  }
}
