import 'package:board_money/provider/create_join_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer<CreateJointProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.8),
          toolbarHeight: height * 0.095,
          title: const Text(
            "Create Room",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.8),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                  height: height * 0.85,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Fill Detials",
                              style: TextStyle(fontFamily: "Jost"),
                              textScaler: TextScaler.linear(1.5),
                            )
                          ],
                        ),
                        Gap(height * 0.090),
                        value.textinput(
                            context,
                            value.bank,
                            "Enter Bank Amount",
                            const Icon(Icons.account_balance_rounded)),
                        Gap(height * 0.090),
                        value.textinput(
                            context,
                            value.user,
                            "Enter Each Player Amount",
                            const Icon(Icons.account_balance_wallet))
                      ],
                    ),
                  )),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            value.createRoom(context);
          },
          label: const Text("Create"),
          icon: value.isloading
              ? const SizedBox(
                  height: 20, width: 20, child: CircularProgressIndicator())
              : const Icon(Icons.add),
        ),
      );
    });
  }
}
