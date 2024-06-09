import 'package:board_money/provider/find_friend_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class FindFreindScreen extends StatefulWidget {
  const FindFreindScreen({super.key});

  @override
  State<FindFreindScreen> createState() => _FindFreindScreenState();
}

class _FindFreindScreenState extends State<FindFreindScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer<FindFriendProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          elevation: 10,
          toolbarHeight: height * 0.1,
          title: const Text(
            'Find Freind',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: height * 0.85,
            child: Column(
              children: [
                const Gap(10),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: TextField(
                    controller: value.controller,
                    onChanged: (String txt) {
                      value.friendlist(txt, context);
                    },
                    onSubmitted: (String txt) {
                      value.friendlist(txt, context);
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                      TextInputFormatter.withFunction(
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
                    ],
                    decoration: const InputDecoration(
                        filled: true,
                        hintText: "Enter Username to find",
                        prefixIcon: Padding(
                          padding:
                              EdgeInsets.only(left: 15, top: 10, bottom: 10),
                          child: Text(
                            '#',
                            style: TextStyle(fontWeight: FontWeight.w900),
                            textScaler: TextScaler.linear(1.4),
                          ),
                        )),
                  ),
                ),
                // const Gap(30),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: value.result,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
