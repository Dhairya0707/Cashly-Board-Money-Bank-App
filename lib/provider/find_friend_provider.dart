import 'package:board_money/screen/Chat_page.dart';
import 'package:board_money/utils/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:random_avatar/random_avatar.dart';

class FindFriendProvider extends ChangeNotifier {
  TextEditingController controller = TextEditingController();
  var box = Hive.box("bank");
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Widget result = const Row(
    children: [Text("enter full username to serach")],
  );

  friendlist(String str, context) async {
    if (controller.text.isNotEmpty) {
      if (str != box.get("username")) {
        var data = await firestore.collection("users").doc(str).get();
        if (data.exists) {
          result = friend(context, data["name"], data["username"],
              data["avatar"], data["email"], data["fcmtoken"]);
          notifyListeners();
        } else {
          result = const Row(
            children: [Text("User not found")],
          );
          notifyListeners();
        }
      } else {
        result = const Row(
          children: [Text("Dont use your own username")],
        );
      }
    } else {
      result = const Row(
        children: [Text("enter full username to serach")],
      );
      notifyListeners();
    }
  }

  Widget friend(context, String name, String username, String avatar,
      String email, String fcmtoken) {
    String uname = box.get("username");
    DocumentReference chatlist = firestore.collection("users").doc(uname);
    String chatid = GeneralProvider.chatid(username, uname);
    String unames = box.get("name");
    String usernames = box.get("username");
    String avatars = box.get("avatar");
    String emails = box.get("email");
    String fcmtokens = box.get("fcmtoken");
    return ListTile(
      onTap: () async {
        try {
          var data = await firestore
              .collection("chat")
              .doc(chatid)
              .collection("msg")
              .get();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                      name: name,
                      username: username,
                      avatar: avatar,
                      chatid: chatid)));

          if (data.docs.isEmpty) {
            await firestore
                .collection("chat")
                .doc(chatid)
                .collection("msg")
                .add({
              "iscode": false,
              "sender": username,
              "reciever": uname,
              "time": DateTime.now(),
              "msg": "$unames added to your as friend"
            });
          }
          // to the user data // sender
          await chatlist.collection("chatlist").doc(username).set({
            "name": name,
            "username": username,
            "avatar": avatar,
            "chatid": chatid,
            "email": email,
            "fcmtoken": fcmtoken
          });

          // to the front of user data //reciver
          await firestore
              .collection("users")
              .doc(username)
              .collection("chatlist")
              .doc(uname)
              .set({
            "name": unames,
            "username": usernames,
            "avatar": avatars,
            "chatid": chatid,
            "email": emails,
            "fcmtoken": fcmtokens
          });

          controller.clear();

          notifyListeners();
        } catch (e) {
          GeneralProvider.showsnackbar(context, e.toString());
        }
      },
      title: Text(
        name,
        textScaler: const TextScaler.linear(1.3),
      ),
      subtitle: Text(username, textScaler: const TextScaler.linear(1.2)),
      leading: CircleAvatar(
        child: RandomAvatar(avatar),
      ),
    );
  }
}
