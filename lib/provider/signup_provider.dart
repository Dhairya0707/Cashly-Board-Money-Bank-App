import 'package:board_money/utils/gate/connection_gate.dart';
import 'package:board_money/utils/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class SignupProvider extends ChangeNotifier {
  TextEditingController username = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool pas = true;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var box = Hive.box("bank");
  final firebasemsg = FirebaseMessaging.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool isloading = false;

  void signup(context) async {
    isloading = true;
    notifyListeners();
    if (username.text.isNotEmpty && pass.text.isNotEmpty) {
      String user = username.text.trim();
      String password = pass.text.trim();

      DocumentSnapshot docSnapshot =
          await firestore.collection("users").doc(user).get();
      if (docSnapshot.exists) {
        String pass = docSnapshot["password"];
        if (pass == password) {
          String name = docSnapshot["name"];
          String email = docSnapshot["email"];
          String svg = docSnapshot["avatar"];
          logintoapp(context, name, username.text, email, svg, password);
          isloading = false;
          notifyListeners();
        } else {
          GeneralProvider.showsnackbar(context, "Password is incorrect");
          isloading = false;
          notifyListeners();
        }
      } else {
        GeneralProvider.showsnackbar(context, "User not found");
        isloading = false;
        notifyListeners();
      }
    } else {
      GeneralProvider.showsnackbar(context, "Please fill all the fields");
      isloading = false;
      notifyListeners();
    }
  }

  void logintoapp(context, names, usernames, emails, svg, passwords) async {
    box.put("isLogin", true);
    box.put("name", names);
    box.put("username", usernames);
    box.put("email", emails);
    box.put("avatar", svg);
    box.put("passowrd", passwords);
    box.put("fcmtoken", await firebasemsg.getToken() ?? "not given");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ConnectionGate()),
        (route) => false);
    GeneralProvider.showsnackbar(context, "Login Successful");
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
