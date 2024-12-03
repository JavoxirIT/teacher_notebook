import 'package:TeamLead/navigation/drawer_list.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      // backgroundColor: Color.fromARGB(255, 182, 137, 2),
      child: DrawerList(),
    );
  }
}
