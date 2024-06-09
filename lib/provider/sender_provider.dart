import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SenderProvider with ChangeNotifier {
  TextEditingController controller = TextEditingController();
  bool isloading = false;

  void transfer(context, roomid, fromid, toid, from, to) async {
    if (controller.text.isNotEmpty &&
        double.tryParse(controller.text) != null &&
        double.parse(controller.text) > 0) {
      try {
        DocumentSnapshot fromUserRef = await FirebaseFirestore.instance
            .collection('game')
            .doc(roomid)
            .collection("userlist")
            .doc(fromid)
            .get();

        DocumentSnapshot toUserRef = await FirebaseFirestore.instance
            .collection('game')
            .doc(roomid)
            .collection("userlist")
            .doc(toid)
            .get();

        // Check if the fromUser has sufficient balance
        if (fromUserRef['amount'] >= int.parse(controller.text)) {
          await FirebaseFirestore.instance
              .collection('game')
              .doc(roomid)
              .collection("userlist")
              .doc(toid)
              .update(
                  {"amount": toUserRef['amount'] + int.parse(controller.text)});
          await FirebaseFirestore.instance
              .collection('game')
              .doc(roomid)
              .collection("userlist")
              .doc(fromid)
              .update({
            "amount": fromUserRef['amount'] - int.parse(controller.text)
          });
          FirebaseFirestore.instance
              .collection('game')
              .doc(roomid)
              .collection("transactions")
              .doc()
              .set({
            "amount": int.parse(controller.text),
            "to": to,
            "from": from,
            "time": DateTime.now()
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Done transaction.'),
              duration: Duration(seconds: 1),
            ),
          );
          controller.clear();
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
          // ignore: use_build_context_synchronously
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not enough balance for the transaction.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction failed: $error'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid positive number.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
