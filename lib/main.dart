import 'package:flutter/material.dart';

import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSwatch().copyWith(
        //   primary: Color(0xff31AC8E),
        // ),

        primaryColor: Colors.green[400],
      ),
      home: MainScreen(),
    );
  }
}
