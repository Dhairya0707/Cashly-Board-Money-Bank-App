import 'package:board_money/screen/Create_page.dart';
import 'package:board_money/screen/Find_page.dart';
import 'package:board_money/utils/gate/connection_gate.dart';
import 'package:board_money/utils/gate/game_gate.dart';
import 'package:board_money/utils/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

class HomeProvider extends ChangeNotifier {
  FocusNode focusNode = FocusNode();
  TextEditingController controller = TextEditingController();
  bool isclose = true;
  var box = Hive.box("bank");

  int current = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Color appbarcolor(context) {
    return Theme.of(context).primaryColorDark.withOpacity(0.8);
  }

  void controllbtn(context) {
    if (current == 0) {
      if (isclose) {
        //create
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CreateScreen()));
      } else {
        //join
        String code = controller.text;

        join(code, context);
      }
    } else {
      //chat
      // frined();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FindFreindScreen()));
    }
  }

  void join(String code, context) async {
    try {
      if (code.length == 8 &&
          RegExp(r'^[0-9]+$').hasMatch(code) &&
          int.tryParse(code) != null &&
          int.parse(code) >= 0) {
        var document = await firestore.collection('game').doc(code).get();

        bool exist = document.exists;

        if (exist) {
          controller.clear();
          isclose = true;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GameAuth(
                        code: code,
                      )));
        } else {
          GeneralProvider.showsnackbar(
              context, "Game room not exist or deleted");
        }
      } else {
        GeneralProvider.showsnackbar(
            context, "Invaild code formate it must be 8 digits number only !");
      }
    } catch (e) {
      GeneralProvider.showsnackbar(context, e.toString());
    }
  }

  void logout(context) {
    box.put("isLogin", false);
    notifyListeners();
    box.put("name", "");
    box.put("username", "");
    box.put("email", "");
    box.put("avatar", "");
    box.put("passowrd", "");
    box.put("fcmtoken", "");
    box.put("histroylist", []);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ConnectionGate()),
        (route) => false);
    GeneralProvider.showsnackbar(context, "Login Successful");
    notifyListeners();
  }

  void onchange(String txt) {
    if (txt.isNotEmpty) {
      isclose = false;
    } else {
      isclose = true;
    }
    notifyListeners();
  }

  void close() {
    controller.clear();
    isclose = true;
    focusNode.unfocus();
    notifyListeners();
  }

  Widget floatingicon() {
    if (current == 0) {
      if (isclose) {
        return const Icon(Icons.create);
      } else {
        return const Icon(Icons.group);
      }
    } else {
      return const Icon(Icons.group_add_sharp);
    }
  }

  List<BottomNavigationBarItem> bottomitem() {
    return [
      const BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded), label: "Home"),
      const BottomNavigationBarItem(
          icon: Icon(Icons.forum_rounded), label: "Message")
    ];
  }

  Widget floatingtext() {
    if (current == 0) {
      if (isclose) {
        return const Text("Create");
      } else {
        return const Text("Join");
      }
    } else {
      return const Text("Find Friend");
    }
  }

  Widget history() {
    bool ischeck = Hive.box("bank").containsKey("histroylist");
    List arrya = Hive.box("bank").get("histroylist") ?? [];
    return Column(
      children: [
        ischeck
            ? Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "History ",
                          textScaler: TextScaler.linear(1.2),
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                    const Gap(20),
                    Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: arrya.length,
                          itemBuilder: (BuildContext context, int index) {
                            DateTime itemTime = arrya[index]["time"];
                            DateTime currentTime = DateTime.now();

                            Duration difference =
                                currentTime.difference(itemTime);

                            String displayText;
                            if (difference.inHours > 24) {
                              displayText =
                                  DateFormat('h:mm a').format(itemTime);
                            } else {
                              // Display a different text or leave it empty
                              // displayText = "24 hours ago";
                              displayText =
                                  DateFormat('d/M/y').format(itemTime);
                            }
                            return ListTile(
                              onTap: () async {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GameAuth(code: arrya[index]["id"])),
                                    (route) => false);
                              },
                              leading: const CircleAvatar(
                                child: Icon(Icons.videogame_asset_rounded),
                              ),
                              title: Text(arrya[index]["id"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  "created by ${arrya[index]["owner"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500)),
                              trailing: Text(displayText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : nohistory(),
      ],
    );
  }

  Widget nohistory() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(100),
          Icon(
            Icons.event_note_rounded,
            size: 80,
          ),
          Gap(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No history yet!",
                style: TextStyle(fontWeight: FontWeight.w500),
                textScaler: TextScaler.linear(2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
