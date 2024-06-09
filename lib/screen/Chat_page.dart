// ignore_for_file: must_be_immutable

import 'package:board_money/utils/gate/game_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:random_avatar/random_avatar.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {super.key,
      required this.name,
      required this.username,
      required this.avatar,
      required this.chatid});
  String name;
  String username;
  String avatar;
  String chatid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  String uname = Hive.box("bank").get("username");

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: height * 0.08,
          title: Row(
            children: [
              CircleAvatar(
                child: RandomAvatar(
                  widget.avatar,
                ),
              ),
              const Gap(20),
              Text(
                widget.name,
                style: const TextStyle(fontWeight: FontWeight.w700),
                textScaler: const TextScaler.linear(1.2),
              ),
            ],
          ),
          // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded))),
      body: SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 5, right: 5, bottom: 0),
            child: SafeArea(
              child: Column(
                children: [
                  Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(25))),
                    elevation: 10,
                    color: Theme.of(context).primaryColorDark,
                    child: Center(
                      child: SizedBox(
                        height: height * 0.865,
                        // heigh,
                        width: width * 0.9,
                        child: Column(
                          children: [
                            // Text("data")
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 15),
                              child: SizedBox(
                                height: height * 0.75,
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("chat")
                                      .doc(widget.chatid)
                                      .collection("msg")
                                      .orderBy("time", descending: true)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    var data = snapshot.data;
                                    List<dynamic> list = [];
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (snapshot.hasError) {
                                      return const Center(
                                        child: Text("Something went wrong"),
                                      );
                                    }
                                    if (snapshot.data != null) {
                                      list = data.docs
                                          .map((doc) => doc.data())
                                          .toList();
                                    }

                                    return ListView.builder(
                                      reverse: true,
                                      itemCount: list.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return msg(
                                          list[index]["sender"],
                                          list[index]["reciever"],
                                          list[index]["msg"],
                                          list[index]["time"],
                                          list[index]["iscode"],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.06,
                              width: width * 0.9,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                      width: width * 0.9,
                                      child: SearchBar(
                                        trailing: [
                                          CircleAvatar(
                                            child: IconButton(
                                                onPressed: () async {
                                                  if (controller.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("chat")
                                                        .doc(widget.chatid)
                                                        .collection("msg")
                                                        .add({
                                                      "iscode": false,
                                                      "sender": widget.username,
                                                      "reciever": uname,
                                                      "time": DateTime.now(),
                                                      "msg": controller.text
                                                    });
                                                    controller.clear();
                                                  } else {}
                                                },
                                                icon: const Icon(
                                                    Icons.send_rounded)),
                                          )
                                        ],
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        controller: controller,
                                      )),
                                ],
                              ),
                            ),
                            const Gap(20)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget msg(
    String sender,
    String recivere,
    String msg,
    time,
    bool iscode,
  ) {
    String me = Hive.box("bank").get("username");
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Align(
          alignment:
              sender == me ? Alignment.centerLeft : Alignment.centerRight,
          child: iscode
              ? Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Room Code',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          msg,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent.shade100,
                          ),
                        ),
                        const SizedBox(height: 15),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GameAuth(code: msg)),
                                (route) => false);
                          },
                          label: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Text(
                              'Join Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              // ? Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(10),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "Room code: $msg",
              //             style: const TextStyle(fontWeight: FontWeight.w500),
              //           ),
              //           Text("created by #$sender",
              //               style:
              //                   const TextStyle(fontWeight: FontWeight.w500)),
              //           const Gap(10),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 15, right: 15),
              //             child: FilledButton.icon(
              //               onPressed: () {
              //                 Navigator.pushAndRemoveUntil(
              //                     context,
              //                     MaterialPageRoute(
              //                         builder: (context) =>
              //                             GameAuth(code: msg)),
              //                     (route) => false);
              //               },
              //               label: const Text("Join now"),
              //               icon: const Icon(Icons.arrow_right_alt_rounded),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   )
              : Card(
                  color: sender == me
                      ? Theme.of(context).primaryColorLight.withOpacity(0.4)
                      : Theme.of(context).primaryColorLight.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      msg,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      textScaler: const TextScaler.linear(1.2),
                    ),
                  ),
                )),
    );
  }
}
