import 'dart:io';

import 'package:TeamLead/bloc/theme/theme_cubit.dart';
import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:TeamLead/style/outline_button_theme_danger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawerList extends StatefulWidget {
  const DrawerList({
    super.key,
  });

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  final dartThemeIcon = const Icon(Icons.mode_night_outlined);
  final lightThemeIcon = const Icon(Icons.sunny);

  @override
  Widget build(BuildContext context) {
    final isTheme = context.watch<ThemeCubit>().state.isTheme;
    return Column(
      children: [
        UserAccountsDrawerHeader(
          // accountName:  Text("Хасанов Жавохир", style: Theme.of(context).textTheme.bodyMedium),
          accountName: Text(
            "",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          accountEmail: const Text(""),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Icon(Icons.man),
            ),
          ),
          decoration: const BoxDecoration(
            // color: Colors.pinkAccent,
            image: DecorationImage(
              image: AssetImage("assets/bg/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          // onDetailsPressed: () {
          //   log("click");
          // },
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
                  title: Text("Ученики",
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
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  leading: const FaIcon(FontAwesomeIcons.gear),
                  title: Text("Настройки",
                      style: Theme.of(context).textTheme.titleSmall),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(RouteName.settingView);
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
                    leading: isTheme ? dartThemeIcon : lightThemeIcon,
                    title: Text('Сменить тему',
                        style: Theme.of(context).textTheme.titleSmall),
                    onTap: () {
                      context.read<ThemeCubit>().setThemeBrightness(
                          isTheme ? Brightness.light : Brightness.dark);
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Вы действительно хотите выйти из приложения?",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  OverflowBar(
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
