// ignore_for_file: use_build_context_synchronously

import 'package:board_money/utils/gate/connection_gate.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({super.key});

  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Cashly",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 100,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                const Gap(50),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Oh-no!",
                      style: TextStyle(fontWeight: FontWeight.w600),
                      textScaler: TextScaler.linear(2.2),
                    ),
                  ],
                ),
                const Gap(10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "We couldn't connect to the internet.\nPlease check your connection.",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                      textScaler: TextScaler.linear(1.2),
                    ),
                  ],
                ),
                Gap(height * 0.09),
                // OutlinedButton(onPressed: onPressed, child: child)
                OutlinedButton.icon(
                  // style: ButtonStyle(
                  //     iconColor: const WidgetStatePropertyAll(Colors.black),
                  //     backgroundColor:
                  //         WidgetStateProperty.all(Colors.lightBlue.shade400)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(
                    "Try again !",
                    // style: TextStyle(color: Colors.black),
                    textScaler: TextScaler.linear(1.8),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final connectivityResult =
                        await Connectivity().checkConnectivity();
                    ConnectivityResult result = connectivityResult[0];

                    Navigator.pop(context);
                    if (result != ConnectivityResult.none) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConnectionGate(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
