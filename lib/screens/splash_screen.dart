import 'dart:async';
import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () {
        isLogged();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Grocery store'),
      ),
    );
  }

  isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? isLogged = prefs.getBool('isLogged');

    if (isLogged != null) {
      if (isLogged) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MobileLogin(),
            ),
            (route) => false);
      }
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MobileLogin(),
          ),
          (route) => false);
    }
  }
}
