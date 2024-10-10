import 'dart:io';

import 'package:assistant/bloc/theme_bloc/theme_bloc_bloc.dart';
import 'package:assistant/style/outline_button_theme_danger.dart';
import 'package:assistant/theme/dark_theme.dart';
import 'package:assistant/theme/green_theme.dart';
import 'package:assistant/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:assistant/constants/route_name/route_name.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerList extends StatefulWidget {
  const DrawerList({
    super.key,
  });

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  SharedPreferences? _pref;
  static const String keyThemeBoll = "theme_bool";
  bool boolData = true;

  final dartThemeIcon = const Icon(Icons.mode_night_outlined);
  final lightThemeIcon = const Icon(Icons.sunny);

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() => _pref = value);
      _loadedBollData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserAccountsDrawerHeader(
          // accountName:  Text("Хасанов Жавохир", style: Theme.of(context).textTheme.bodyMedium),
          accountName: Text("Хасанов Жавохир",
              style: Theme.of(context).textTheme.titleSmall),
          accountEmail: const Text(""),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.asset('assets/images/aka.jpg'),
            ),
          ),
          decoration: const BoxDecoration(
            // color: Colors.pinkAccent,
            image: DecorationImage(
              image: AssetImage("assets/bg/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(
                    Icons.home,
                  ),
                  title: Text("Главная",
                      style: Theme.of(context).textTheme.titleSmall),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(RouteName.homeScreen);
                  },
                ),
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.account_box,
              //   ),
              //   title: Text("Все учиники",
              //       style: Theme.of(context).textTheme.titleSmall),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.of(context).pushNamed(RouteName.studentsScreen);
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.userPlus,
                  ),
                  title: Text("Действия",
                      style: Theme.of(context).textTheme.titleSmall),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(RouteName.addStudentsScreen);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.users,
                  ),
                  title: Text("Учиники",
                      style: Theme.of(context).textTheme.titleSmall),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(RouteName.localStudent);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.cashRegister,
                  ),
                  title: Text("Оплата",
                      style: Theme.of(context).textTheme.titleSmall),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(RouteName.paymentsScreen);
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(height: 5.0),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: ListTile(
                    leading: boolData ? dartThemeIcon : lightThemeIcon,
                    title: Text('Сменить тему',
                        style: Theme.of(context).textTheme.titleSmall),
                    onTap: () {
                      BlocProvider.of<ThemeBlocBloc>(context).add(
                        ThemeAddEvent(
                            theme: boolData
                                ? lightTheme
                                : boolData == true
                                    ? darkTheme
                                    : greenTheme),
                      );
                      boolData = !boolData;
                      // _setBollPref(!boolData);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
                  child: ListTile(
                    leading: const Icon(Icons.exit_to_app_rounded),
                    title: Text(
                      'Выход',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    onTap: () => showModal(context),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  // Future<void> _setBollPref(bool value) async {
  //   await _pref!.setBool(keyThemeBoll, value);
  //   _loadedBollData();
  // }

  // Future<void> _resetData() async {
  //   await _pref!.remove(keyThemeBoll);
  //   _loadedBollData();
  // }

  void _loadedBollData() {
    setState(() {
      boolData = _pref!.getBool(keyThemeBoll) ?? true;
      // debugPrint("$boolData");
    });
  }

  void showModal(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Подтверждение",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Вы действительно хотите выйти из приложения?",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  ButtonBar(
                    children: [
                      OutlinedButton(
                        style: outlineButtonStyleDanger,
                        onPressed: () {
                          if (Platform.isAndroid) {
                            SystemChannels.platform
                                .invokeMethod('SystemNavigator.pop');
                          } else {
                            exit(0);
                          }
                        },
                        child: const Text("Выйти"),
                      ),
                      OutlinedButton(
                        child: const Text("Остатся"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
}
