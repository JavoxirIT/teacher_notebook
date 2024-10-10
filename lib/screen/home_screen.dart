import 'package:assistant/widgets/group/group_list.dart';
import 'package:flutter/material.dart';
import 'package:assistant/navigation/drawer_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Главная"),
        // centerTitle: true,
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          SizedBox(
            // height: 30.0,
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 27.0, vertical: 10.0),
              child: Text(
                "Статистика",
              ),
            ),
          ),
          info(),
          SizedBox(
            // height: 30.0,
            width: MediaQuery.of(context).size.width,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 27),
              child: Text(
                "Список групп",
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(
              // height: MediaQuery.of(context).size.height / 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GroupList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GridView info() {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      // itemCount: 4,
      children: [
        Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Количество уч.',
                ),
                Text(
                  '50',
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Center(
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Бесплатно'),
                Text('15'),
              ],
            ),
          ),
        ),
        Card(
          child: Center(
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Платно'),
                Text('35'),
              ],
            ),
          ),
        ),
        Card(
          child: Center(
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Оплатили за месяц"),
                Text('20'),
              ],
            ),
          ),
        ),
      ],
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 5,
        mainAxisExtent: 120,
      ),
    );
  }
}
