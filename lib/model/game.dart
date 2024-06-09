import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String id;
  final String ownerId;
  final String ownerName;
  final double bankAmount;
  final double playerAmount;
  final DateTime time;

  Game({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.bankAmount,
    required this.playerAmount,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'Bank': bankAmount,
      'player': playerAmount,
      'time': time,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      ownerId: map['ownerId'],
      ownerName: map['ownerName'],
      bankAmount: map['Bank'],
      playerAmount: map['player'],
      time: (map['time'] as Timestamp).toDate(),
    );
  }
}
