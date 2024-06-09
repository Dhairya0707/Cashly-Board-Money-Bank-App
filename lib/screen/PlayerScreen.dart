import 'package:board_money/provider/game_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key, required this.code});
  final String code;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    Provider.of<GameProvider>(context, listen: false)
        .updatedrawerdata(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int currentPage = 0;
    PageController controller = PageController(initialPage: currentPage);
    String code = widget.code;
    return Consumer<GameProvider>(builder: (context, value, child) {
      //update data in drawer

      //
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: height * 0.09,
          leading: const DrawerButton(),
        ),
        body: SafeArea(
          child: SizedBox(
            height: height * 0.86,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.28,
                    child: PageView(
                      controller: controller,
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      children: [
                        value.usercard(height, width, code, context, true),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
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
                                  value.showplayerdata(code, context);
                                },
                                icon: const Icon(Icons.error_outline_rounded))
                          ],
                        ),
                        SizedBox(
                          height: 70,
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
                                  scrollDirection: Axis.horizontal,
                                  itemCount: users.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: value.playername(
                                          users[index]['name'],
                                          users[index]['isBank']
                                              ? const Icon(
                                                  Icons.account_balance_rounded)
                                              : const Icon(
                                                  Icons.person_rounded)),
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
                                .doc(code)
                                .collection('transactions')
                                .orderBy("time", descending: true)
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
                                  scrollDirection: Axis.vertical,
                                  itemCount: users.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: value.listtile(
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        drawer: value.drawer(code, context),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            value.showsheetforowner(context, code, true);
          },
          label: const Text(
            "Send",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          icon: const Icon(Icons.payments_outlined),
        ),
      );
    });
  }
}
