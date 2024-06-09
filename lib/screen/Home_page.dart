// ignore_for_file: file_names
import 'package:board_money/provider/home_provider.dart';
import 'package:board_money/screen/About_page.dart';
import 'package:board_money/screen/friendlist_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var box = Hive.box("bank");

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    String svg = box.get("avatar") ?? DateTime.now().toIso8601String();

    return Consumer<HomeProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: value.current == 0
              ? value.appbarcolor(context)
              : Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: value.current == 0 ? true : false,
          scrolledUnderElevation: 0,
          toolbarHeight: height * 0.1,
          title: value.current == 0
              ? SearchBar(
                  hintText: "Enter Code",
                  hintStyle: const WidgetStatePropertyAll(
                      TextStyle(fontWeight: FontWeight.w700)),
                  focusNode: value.focusNode,
                  keyboardType: TextInputType.number,
                  controller: value.controller,
                  onChanged: value.onchange,
                  trailing: [
                    value.isclose
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5, right: 10),
                            child: CircleAvatar(
                              child: RandomAvatar(svg),
                            ),
                          )
                        : IconButton(
                            onPressed: value.close,
                            icon: const Icon(Icons.close_rounded))
                  ],
                  leading: const DrawerButton(),
                  elevation: const WidgetStatePropertyAll(0),
                )
              : const Text(
                  "Chat Msg",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
        ),
        body: SafeArea(
            child: SizedBox(
                height: height * 0.8,
                child: value.current == 0
                    ? value.history()
                    : Padding(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                            height: height * 0.8, child: const Friendlist()),
                      ))),

        //bottom navigation bar
        bottomNavigationBar: SizedBox(
          height: height * 0.08,
          child: BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColorDark,
              type: BottomNavigationBarType.fixed,
              useLegacyColorScheme: false,
              onTap: (index) {
                value.current = index;
                setState(() {});
              },
              currentIndex: value.current,
              showUnselectedLabels: false,
              showSelectedLabels: true,
              landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
              iconSize: 30,
              items: value.bottomitem()),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            value.controllbtn(context);
          },
          label: value.floatingtext(),
          icon: value.floatingicon(),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              const DrawerHeader(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Cashly",
                    style: TextStyle(fontWeight: FontWeight.w700),
                    textScaler: TextScaler.linear(1.8),
                  ),
                ],
              )),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textScaler: TextScaler.linear(1),
                ),
                subtitle: Text(
                  box.get("name"),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  textScaler: const TextScaler.linear(1.5),
                ),
              ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 5, top: 10, bottom: 10),
                  child: Text(
                    '#',
                    style: TextStyle(fontWeight: FontWeight.w900),
                    textScaler: TextScaler.linear(2),
                  ),
                ),
                title: const Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textScaler: TextScaler.linear(1),
                ),
                subtitle: Text(
                  box.get("username"),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  textScaler: const TextScaler.linear(1.2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline_rounded),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
                title: const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textScaler: TextScaler.linear(1),
                ),
                subtitle: const Text(
                  "about the cashly app",
                  style: TextStyle(fontWeight: FontWeight.w600),
                  textScaler: TextScaler.linear(1.5),
                ),
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      onTap: () {
                        value.logout(context);
                      },
                      leading: const Icon(Icons.exit_to_app_rounded),
                      title: const Text(
                        "Logout",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textScaler: TextScaler.linear(1.2),
                      ),
                      subtitle: const Text(
                        "LogOut account",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textScaler: TextScaler.linear(1),
                      ),
                    ),
                    const ListTile(
                      leading: Icon(Icons.phone_android_rounded),
                      title: Text(
                        "Made In India 🇮🇳",
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textScaler: TextScaler.linear(1.2),
                      ),
                      subtitle: Text(
                        "Made with ❤ by Dhairya",
                        style: TextStyle(fontFamily: "Jost"),
                      ),
                    ),
                    const Gap(10)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
