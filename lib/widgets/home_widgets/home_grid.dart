import 'package:flutter/material.dart';

class HomeGrid extends StatefulWidget {
  const HomeGrid(
      {super.key,
      required this.stCount,
      required this.numberOfPaid,
      required this.numberNotOfPaid});

  final int stCount;
  final int numberOfPaid;
  final int numberNotOfPaid;

  @override
  State<HomeGrid> createState() => _HomeGridState();
}

class _HomeGridState extends State<HomeGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 5,
        mainAxisExtent: 100,
      ),
      children: [
        Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ученики',
                ),
                Text(
                  widget.stCount.toString(),
                ),
              ],
            ),
          ),
        ),
        Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Бесплатно'),
                Text(widget.numberNotOfPaid.toString()),
              ],
            ),
          ),
        ),
        Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Платно'),
                Text(widget.numberOfPaid.toString()),
              ],
            ),
          ),
        ),
        const Card(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Оплатили за месяц"),
                Text('0'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
