// ignore_for_file: use_build_context_synchronously

import 'package:board_money/screen/Sender_page.dart';
import 'package:board_money/utils/gate/auth_gate.dart';
import 'package:board_money/utils/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:random_avatar/random_avatar.dart';

class GameProvider extends ChangeNotifier {
  static String id = "";
  static String ownername = "";
  static String bankamount = "";
  static String playeramount = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updatedrawerdata(code) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('game').doc(code).get();

    id = docSnapshot["id"];
    ownername = docSnapshot["username"];
    bankamount = docSnapshot["Bank"].toString();
    playeramount = docSnapshot["player"].toString();
    notifyListeners();
  }

//showplayerdata
  void showplayerdata(roomid, context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double deviceHeight = MediaQuery.of(context).size.width;
        double deviceWidth = MediaQuery.of(context).size.width;
        return alertdiolgeshow(context, roomid, deviceHeight, deviceWidth);
      },
    );
  }

  void share(context) async {
    List<dynamic> list = [];
    bool empty = false;

    String username = Hive.box("bank").get("username");
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(username)
        .collection("chatlist")
        .get();
    if (data.docs.isEmpty) {
      empty = true;
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        double deviceHeight = MediaQuery.of(context).size.width;
        double deviceWidth = MediaQuery.of(context).size.width;

        return empty
            ? Center(
                child: Card(
                  child: SizedBox(
                    height: deviceHeight,
                    width: deviceWidth * 0.9,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No friend found !",
                              style: TextStyle(fontWeight: FontWeight.w500),
                              textScaler: TextScaler.linear(1.5),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Card(
                  child: SizedBox(
                    height: deviceHeight,
                    width: deviceWidth * 0.9,
                    child: Column(
                      children: [
                        const Gap(10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("Select a player to send")],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SizedBox(
                            height: deviceHeight * 0.8,
                            width: deviceWidth * 0.9,
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
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection("chat")
                                              .doc(chatid)
                                              .collection("msg")
                                              .add({
                                            "iscode": true,
                                            "sender": username,
                                            "reciever": ownername,
                                            "time": DateTime.now(),
                                            "msg": id
                                          });
                                          GeneralProvider.showsnackbar(
                                              context, "sended to $username");
                                          notifyListeners();
                                          Navigator.pop(context);
                                        } catch (e) {
                                          GeneralProvider.showsnackbar(
                                              context, e.toString());
                                        }
                                      },
                                      title: Text(
                                        name,
                                        textScaler:
                                            const TextScaler.linear(1.5),
                                      ),
                                      leading: CircleAvatar(
                                        child: RandomAvatar(avatar),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }

  void showsheetforowner(BuildContext context, roomid, isbank) {
    showModalBottomSheet(
      sheetAnimationStyle: AnimationStyle(
          curve: Curves.linear, duration: const Duration(milliseconds: 500)),
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return _buildBottomSheetContent(roomid, context, isbank);
      },
    );
  }

  Widget _buildBottomSheetContent(roomid, context, isbank) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorDark,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose an option to Send',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildList(roomid, isbank),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Back",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList(roomid, bool isbank) {
    String name = Hive.box("bank").get("name");
    String username = Hive.box("bank").get("username");
    return Expanded(
      child: StreamBuilder(
        stream: firestore
            .collection('game')
            .doc(roomid)
            .collection('userlist')
            .where("id", isNotEqualTo: isbank ? username : "cashlybank")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<QueryDocumentSnapshot> users = snapshot.data!.docs;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return sendlist(
                    users[index]['name'],
                    users[index]["isowner"],
                    users[index]['name'],
                    isbank ? name : "Bank",
                    users[index]['id'],
                    isbank ? username : "cashlybank",
                    context,
                    roomid);
              },
            );
          }
        },
      ),
    );
  }

  Widget sendlist(String name, bool isowner, String to, String from,
      String toid, String fromid, context, String roomid) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SenderScreen(
                    to: to,
                    from: from,
                    fromid: fromid,
                    code: roomid,
                    toid: toid)));
      },
      leading: CircleAvatar(
        child: name == "Bank"
            ? const Icon(Icons.account_balance_rounded)
            : isowner
                ? const Icon(Icons.verified_rounded)
                : const Icon(Icons.person),
      ),
      title: Text(
        name,
      ),
      subtitle: Text(
        "send to #$toid",
      ),
      // trailing: Icon(Icons.payments_outlined),
    );
  }

  Widget alertdiolgeshow(context, code, height, width) {
    return Center(
        child: Card(
      child: SizedBox(
        height: height * 1,
        width: width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  const Text(
                    "Player Data",
                    textScaler: TextScaler.linear(1.2),
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Card(
                color: Theme.of(context).primaryColorDark.withOpacity(0.8),
                child: SizedBox(
                  height: height * 0.8,
                  width: width,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: StreamBuilder(
                          stream: firestore
                              .collection('game')
                              .doc(code)
                              .collection('userlist')
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              List<QueryDocumentSnapshot> users =
                                  snapshot.data!.docs;
                              return ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return playerdata(
                                      users[index]["name"],
                                      users[index]["amount"].toString(),
                                      users[index]["isowner"]);
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

//bank card
  Widget bankcard(deviceHeight, width, String roomid, context) {
    // Color tcolor = const Color(0xFF293C55);
    Color tcolor = Colors.white;
    // Color tcolor2 = const Color(0xFF333333);
    Color tcolor2 = Colors.white;
    Color icon = Colors.white;
    return Card(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.65,
              child: Image.asset(
                alignment: Alignment.bottomLeft,
                "asset/bg.jpeg",
                width: width,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // cl1

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Current Balance",
                            style: TextStyle(
                                color: tcolor, fontWeight: FontWeight.w500),
                            // ignore: deprecated_member_use
                            textScaleFactor: 1.1,
                          ),
                          Icon(
                            Icons.credit_card_rounded,
                            color: icon,
                          )
                        ],
                      ),
                      // Gap(deviceHeight * 0.006),
                      Gap(deviceHeight * 0.007),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          StreamBuilder(
                            stream: firestore
                                .collection('game')
                                .doc(roomid)
                                .collection('userlist')
                                .doc("cashlybank")
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  !snapshot.data!.exists) {
                                return const Text('User not found');
                              } else {
                                var amount = snapshot.data!['amount'];
                                return Text(
                                  '\$ ${amount.toString()}',
                                  style: TextStyle(
                                      color: tcolor2,
                                      fontWeight: FontWeight.w700),
                                  // ignore: deprecated_member_use
                                  textScaleFactor: 2.5,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  //cl2
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Cashly Bank",
                              style: TextStyle(
                                  color: tcolor, fontWeight: FontWeight.w600),
                              // ignore: deprecated_member_use
                              textScaleFactor: 1.2,
                            ),
                            Text(
                              "12/26",
                              style: TextStyle(
                                  color: tcolor, fontWeight: FontWeight.w600),
                              // ignore: deprecated_member_use
                              textScaleFactor: 1.2,
                            ),
                          ]),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//user card
  Widget usercard(deviceHeight, width, String roomid, context, bool isbank) {
    var box = Hive.box("bank");
    String username = box.get("username");
    Color tcolor = Colors.white;
    Color tcolor2 = Colors.white;
    Color icon = Colors.white;

    return Card(
      color: Theme.of(context).primaryColorLight.withOpacity(0.3),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            isbank
                ? Opacity(
                    opacity: 0.65,
                    child: Image.asset(
                      alignment: Alignment.center,
                      "asset/back.jpeg",
                      width: width,
                      fit: BoxFit.cover,
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // cl1
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Current Balance",
                            style: TextStyle(
                                color: tcolor, fontWeight: FontWeight.w500),
                            textScaler: const TextScaler.linear(1.1),
                          ),
                          Icon(
                            Icons.credit_card_rounded,
                            color: icon,
                          )
                        ],
                      ),
                      Gap(deviceHeight * 0.005),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          StreamBuilder(
                            stream: firestore
                                .collection('game')
                                .doc(roomid)
                                .collection('userlist')
                                .doc(username)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  !snapshot.data!.exists) {
                                return const Text('User not found');
                              } else {
                                var amount = snapshot.data!['amount'];
                                return Text(
                                  '\$ ${amount.toString()}',
                                  style: TextStyle(
                                      color: tcolor2,
                                      fontWeight: FontWeight.w700),
                                  // ignore: deprecated_member_use
                                  textScaleFactor: 2.5,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  //cl2

                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              Hive.box("bank").get("name"),
                              style: TextStyle(
                                  color: tcolor, fontWeight: FontWeight.w600),
                              // ignore: deprecated_member_use
                              textScaleFactor: 1.2,
                            ),
                            Text(
                              "01/26",
                              style: TextStyle(
                                  color: tcolor, fontWeight: FontWeight.w600),
                              // ignore: deprecated_member_use
                              textScaleFactor: 1.2,
                            )
                          ]),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
//drawer

  Widget drawer(code, context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Cashly",
                style: TextStyle(fontWeight: FontWeight.w700),
                textScaler: TextScaler.linear(1.8),
              ),
            ],
          )),
          ListBody(
            children: [
              ListTile(
                leading: const Icon(Icons.room),
                title: const Text(
                  "Room Id",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  id,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.5,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.face_rounded),
                title: const Text(
                  "Room Owner",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  ownername,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.5,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.business_rounded),
                title: const Text(
                  "Bank Amount",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  "\$ $bankamount",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.2,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.monetization_on),
                title: const Text(
                  "Each Player Amount",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: Text(
                  "\$ $playeramount",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.2,
                ),
              ),
              ListTile(
                onTap: () {
                  share(context);
                  // updatedrawerdata(code);
                },
                leading: const Icon(Icons.share),
                title: const Text(
                  "Share",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: const Text(
                  "Share code to friends",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.2,
                ),
              ),
              ListTile(
                onTap: () {
                  updatedrawerdata(code);
                },
                leading: const Icon(Icons.refresh_rounded),
                title: const Text(
                  "Refresh",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1,
                ),
                subtitle: const Text(
                  "Refresh the Room data",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaleFactor: 1.2,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthGate()),
                      (route) => false);
                },
                leading: const Icon(Icons.exit_to_app_rounded),
                title: const Text(
                  "Exit",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textScaler: TextScaler.linear(1),
                ),
                subtitle: const Text(
                  "Exit the Game Room",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  // ignore: deprecated_member_use
                  textScaler: TextScaler.linear(1.1),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
// body widgets

  Widget bodyscreen(String roomid, context) {
    return Column(
      children: [
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              "Players",
              style: TextStyle(fontWeight: FontWeight.w600),
              textScaler: TextScaler.linear(1.2),
            ),
            IconButton(
                onPressed: () {
                  showplayerdata(roomid, context);
                },
                icon: const Icon(Icons.error_outline_rounded))
          ],
        ),
        SizedBox(
          height: 70,
          child: StreamBuilder(
            stream: firestore
                .collection('game')
                .doc(roomid)
                .collection('userlist')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<QueryDocumentSnapshot> users = snapshot.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: playername(
                          users[index]['name'],
                          users[index]['isBank']
                              ? const Icon(Icons.account_balance_rounded)
                              : const Icon(Icons.person_rounded)),
                    );
                  },
                );
              }
            },
          ),
        ),
        const Gap(20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Transaction",
              style: TextStyle(fontWeight: FontWeight.w600),
              // ignore: deprecated_member_use
              textScaleFactor: 1.2,
            )
          ],
        ),
        // Gap(5),
        Expanded(
          child: StreamBuilder(
            stream: firestore
                .collection('game')
                .doc(roomid)
                .collection('transactions')
                .orderBy("time", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<QueryDocumentSnapshot> users = snapshot.data!.docs;
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: listtile(
                            users[index]["from"],
                            users[index]["to"],
                            users[index]["amount"].toString()));
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }

// list tile
  Widget listtile(String to, String from, String amount) {
    return ListTile(
      title: Text(
        to,
        textScaler: const TextScaler.linear(1.2),
      ),
      subtitle: Text(
        "$from give \$$amount to $to",
        textScaler: const TextScaler.linear(1),
      ),
      trailing: Text(
        "\$$amount",
        style: const TextStyle(fontWeight: FontWeight.w600),
        textScaler: const TextScaler.linear(1.5),
      ),
    );
  }

//playername
  Widget playername(String name, Icon icon) {
    return Chip(
      label: Text(name),
      avatar: icon,
    );
  }

//playerdata
  Widget playerdata(String name, String amount, bool isowner) {
    return ListTile(
        leading: name == "Bank"
            ? const Icon(Icons.account_balance_rounded)
            : isowner
                ? const Icon(Icons.verified_rounded)
                : const Icon(Icons.person),
        title: Text(name),
        trailing: Text(
          "\$ $amount",
          // ignore: deprecated_member_use
          textScaleFactor: 1.5,
        ));
  }

//end
}
