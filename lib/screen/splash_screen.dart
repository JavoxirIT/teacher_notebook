import 'dart:async';
import 'dart:core';

import 'package:TeamLead/constants/route_name/route_name.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed(RouteName.homeScreen);
    });
    super.initState();
  }

  // Widget creation
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "ДОБРО ПОЖАЛОВАТЬ",
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.w800,
                fontSize: 16.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: LinearProgressIndicator(color: Colors.amber),
            )
          ],
        ),
      ),
    );
  }
}
