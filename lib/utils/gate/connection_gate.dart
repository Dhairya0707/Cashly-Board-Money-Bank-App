import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../../screen/Connection_page.dart';
import 'auth_gate.dart';

class ConnectionGate extends StatefulWidget {
  const ConnectionGate({super.key});

  @override
  State<ConnectionGate> createState() => _ConnectionGateState();
}

class _ConnectionGateState extends State<ConnectionGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          ConnectivityResult result =
              snapshot.data[0] ?? ConnectivityResult.none;
          if (result != ConnectivityResult.none) {
            return const AuthGate();
          } else {
            return const ConnectionScreen();
          }
        } else {
          return const AuthGate();
        }
      },
    );
  }
}
