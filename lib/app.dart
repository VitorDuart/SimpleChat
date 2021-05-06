import 'package:flutter/material.dart';
import 'package:simplechat/chart_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Chat(),
    );
  }
}
