import 'package:flutter/material.dart';
import 'package:assistant/navigation/drawer_list.dart';

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
