import 'package:board_money/screen/Chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:random_avatar/random_avatar.dart';

class Friendlist extends StatefulWidget {
  const Friendlist({super.key});

  @override
  State<Friendlist> createState() => _FriendlistState();
}

class _FriendlistState extends State<Friendlist> {
  List<dynamic> list = [];
  bool isloading = true;
  bool empty = false;

  @override
  void initState() {
    super.initState();
    fetch();
    setState(() {});
  }

  void fetch() async {
    String username = Hive.box("bank").get("username");
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(username)
        .collection("chatlist")
        .get();
    if (data.docs.isEmpty) {
      isloading = false;
      empty = true;
      print(empty);
      setState(() {});
    }
    List<dynamic> list2 = data.docs.map((doc) => doc.data()).toList();
    for (var i = 0; i < list2.length; i++) {
      list.add({
        "name": list2[i]["name"],
        "username": list2[i]["username"],
        "avatar": list2[i]["avatar"],
        "chatid": list2[i]["chatid"],
      });
    }
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : empty
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.group_add_rounded,
                    size: 80,
                  ),
                  Gap(50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Start chatting now!",
                        style: TextStyle(fontWeight: FontWeight.w500),
                        textScaler: TextScaler.linear(2),
                      ),
                    ],
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    String name = list[index]["name"];
                    String username = list[index]["username"];
                    String avatar = list[index]["avatar"];
                    String chatid = list[index]["chatid"];

                    return Column(
                      children: [
                        ListTile(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        name: name,
                                        username: username,
                                        avatar: avatar,
                                        chatid: chatid)));
                          },
                          title: Text(
                            name,
                            textScaler: const TextScaler.linear(1.5),
                          ),
                          // subtitle: Text(username, textScaler: const TextScaler.linear(1.2)),
                          leading: CircleAvatar(
                            child: RandomAvatar(avatar),
                          ),
                        ),
                        const Gap(10)
                      ],
                    );
                  },
                ),
              );
  }
}
