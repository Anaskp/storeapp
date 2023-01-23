import 'dart:async';

import 'package:e_store/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/providers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () {
        isLogged();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Grocery store'),
      ),
    );
  }

  isLogged() async {
    final prefs = await SharedPreferences.getInstance();
    //final ap = Provider.of<AuthProvider>(context, listen: false);
    final bool? isLogged = prefs.getBool('isLogged');

    if (isLogged != null) {
      if (isLogged) {
        // final String? _name = prefs.getString('name');
        // ap.userName = _name ?? '';
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MainScreen(),
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
