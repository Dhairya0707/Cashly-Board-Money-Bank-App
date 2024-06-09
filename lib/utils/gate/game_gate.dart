import 'package:board_money/screen/OwnerScreen.dart';
import 'package:board_money/screen/PlayerScreen.dart';
import 'package:board_money/utils/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class GameAuth extends StatefulWidget {
  const GameAuth({super.key, required this.code});
  final String code;
  @override
  State<GameAuth> createState() => _GameAuthState();
}

class _GameAuthState extends State<GameAuth> {
  var box = Hive.box("bank");
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    check(context);
  }

  void check(context) async {
    try {
      String code = widget.code;
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('game').doc(code).get();
      DocumentReference game = firestore.collection("game").doc(code);
      String id = await docSnapshot["username"];
      String username = box.get("username");
      String name = box.get("name");

      if (id == username) {
        //user is owner
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => Ownerscreen(
                      code: code,
                    )),
            (route) => false);
      } else {
        //user is player not owner

        var user = await firestore
            .collection('game')
            .doc(code)
            .collection("userlist")
            .doc(username)
            .get();

        if (user.exists) {
          //user data exist
          GeneralProvider.showsnackbar(context, "You are already in this game");
          //to the user screen
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                        code: code,
                      )),
              (route) => false);
        } else {
          //user data not exist
          await game.collection("userlist").doc(username).set({
            "name": name,
            "id": username,
            "amount": await GeneralProvider.getplayeramount(code, context),
            "isowner": false,
            "isBank": false
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                        code: code,
                      )),
              (route) => false);
          GeneralProvider.showsnackbar(context, "Sussecfully entered the game");

          GeneralProvider.makelocalhistroy(code, id);
        }
      }
    } catch (e) {
      GeneralProvider.showsnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
