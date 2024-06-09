import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GeneralProvider {
  static showsnackbar(context, String txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(txt),
      duration: const Duration(milliseconds: 2500),
      showCloseIcon: true,
    ));
  }

  static Future<double> getbankamount(code, context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot docSnapshot =
        await firestore.collection('game').doc(code).get();
    double bankAmount = docSnapshot['Bank'];
    return bankAmount;
  }

  static Future<double> getplayeramount(code, context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot docSnapshot =
        await firestore.collection('game').doc(code).get();
    double bankAmount = docSnapshot["player"];
    return bankAmount;
  }

  static void makelocalhistroy(
    String id,
    String owner,
  ) {
    List array = Hive.box("bank").get("histroylist") ?? [];
    array.add({"id": id, "owner": owner, "time": DateTime.now()});
    Hive.box("bank").put("histroylist", array);
  }

  static String chatid(String username1, String username2) {
    // Compare the first characters of both usernames using ASCII values
    if (username1.codeUnitAt(0).compareTo(username2.codeUnitAt(0)) <= 0) {
      return '${username1}_$username2';
    } else {
      return '${username2}_$username1';
    }
  }
}
