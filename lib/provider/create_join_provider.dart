import 'dart:math';
import 'package:board_money/utils/gate/game_gate.dart';
import 'package:board_money/utils/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateJointProvider extends ChangeNotifier {
  var box = Hive.box("bank");
  TextEditingController user = TextEditingController();
  TextEditingController bank = TextEditingController();
  bool isloading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static String? _uniqueCode;

  static String generateRandomCode() {
    const chars = '0123456789';
    final random = Random();
    String code = '';
    for (int i = 0; i < 8; i++) {
      code += chars[random.nextInt(chars.length)];
    }
    return code;
  }

  static Future<String> getUniqueCode() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (_uniqueCode == null) {
      do {
        _uniqueCode = generateRandomCode();
        final usersRef = firestore.collection('game');
        final doc = usersRef.doc(_uniqueCode);
        final docSnapshot = await doc.get();
        if (docSnapshot.exists) {
          _uniqueCode = null;
        }
      } while (_uniqueCode == null);
    }
    return _uniqueCode!;
  }

  void createRoom(context) async {
    try {
      //uniqe code
      isloading = true;
      notifyListeners();
      String name = box.get("name");
      String username = box.get("username");
      String code = await getUniqueCode();
      DocumentReference game = firestore.collection("game").doc(code);

      if (checkcontoller(context)) {
        // get amounts
        double enteredBank = double.parse(bank.text);
        double enteredPlayer = double.parse(user.text);
        //game create
        await game.set({
          "Bank": enteredBank,
          "player": enteredPlayer,
          "id": code,
          "username": username,
          "onwername": name,
          "time": DateTime.now()
        });
        //create user
        await game.collection("userlist").doc(username).set({
          "name": name,
          "id": username,
          "amount": await GeneralProvider.getplayeramount(code, context),
          "isowner": true,
          "isBank": false
        });

        //create bank
        await game.collection("userlist").doc("cashlybank").set({
          "name": "Bank",
          "id": "cashlybank",
          "amount": await GeneralProvider.getbankamount(code, context),
          "ownername": name,
          "ownerid": username,
          "isowner": false,
          "isBank": true,
        });

        //make local history
        GeneralProvider.makelocalhistroy(code, "#$username");
        //snackbar
        GeneralProvider.showsnackbar(context, "Game Created !");
        //navigation
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => GameAuth(
                      code: code,
                    )),
            (route) => false);

        isloading = false;
        notifyListeners();
      } else {
        GeneralProvider.showsnackbar(context,
            "Invalid input. Please enter valid numbers for both Bank and Player");
        isloading = false;
        notifyListeners();
      }
    } catch (e) {
      GeneralProvider.showsnackbar(context, e.toString());
      isloading = false;
      notifyListeners();
    }
  }

  bool checkcontoller(context) {
    if (bank.text.isNotEmpty &&
        double.tryParse(bank.text) != null &&
        double.parse(bank.text) > 0 &&
        user.text.isNotEmpty &&
        double.tryParse(user.text) != null &&
        double.parse(user.text) > 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget textinput(
      context, TextEditingController controller, String hinttext, Icon icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        // fillColor: Theme.of(context).primaryColorLight.withOpacity(0.3),
        filled: true,
        hintText: hinttext,
        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
        prefixIcon: icon,
      ),
      onChanged: (value) {},
    );
  }
}
