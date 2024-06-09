import 'package:board_money/model/theme.dart';
import 'package:board_money/model/util.dart';
import 'package:board_money/provider/create_join_provider.dart';
import 'package:board_money/provider/find_friend_provider.dart';
import 'package:board_money/provider/game_provider.dart';
import 'package:board_money/provider/home_provider.dart';
import 'package:board_money/provider/login_provider.dart';
import 'package:board_money/provider/sender_provider.dart';
import 'package:board_money/provider/signup_provider.dart';
import 'package:board_money/utils/gate/connection_gate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'utils/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox('bank');
  await FirebaseMessaging.instance.requestPermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito", "Jost");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => SignupProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => FindFriendProvider()),
          ChangeNotifierProvider(create: (_) => CreateJointProvider()),
          ChangeNotifierProvider(create: (_) => GameProvider()),
          ChangeNotifierProvider(create: (_) => SenderProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme.dark(),
          home: const ConnectionGate(),
        ));
  }
}
