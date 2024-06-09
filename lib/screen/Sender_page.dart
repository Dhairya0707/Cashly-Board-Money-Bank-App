// ignore_for_file: must_be_immutable

import 'package:board_money/provider/sender_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SenderScreen extends StatefulWidget {
  String to;
  String from;
  String code;
  String fromid;
  String toid;
  SenderScreen(
      {super.key,
      required this.to,
      required this.from,
      required this.fromid,
      required this.code,
      required this.toid});

  @override
  State<SenderScreen> createState() => _SenderScreenState();
}

class _SenderScreenState extends State<SenderScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SenderProvider>(builder: (context, value, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Send Money",
              style: TextStyle(

                  // color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.wallet_rounded),
                    ),
                    title: Text(
                      widget.to,
                    ),
                    subtitle: Text(
                      "From #${widget.fromid}",
                    ),
                  ),
                ),
                const Gap(10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Amount",
                      textScaler: TextScaler.linear(1.2),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const Gap(10),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.attach_money_rounded),
                    title: TextField(
                      controller: value.controller,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      enableSuggestions: false,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                // Spacer(),
                const Expanded(child: SizedBox()),
                SlideAction(
                  onSubmit: () async {
                    value.transfer(context, widget.code, widget.fromid,
                        widget.toid, widget.from, widget.to);
                  },
                  borderRadius: 20,
                  innerColor: Colors.greenAccent.shade100,
                  outerColor: Colors.green.shade400,
                  submittedIcon: const Icon(
                    Icons.payments_rounded,
                    opticalSize: 10,
                  ),
                  child: const Text(
                    "Slide To Pay",
                    // ignore: deprecated_member_use
                    textScaleFactor: 1.6,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          )));
    });
  }
}
