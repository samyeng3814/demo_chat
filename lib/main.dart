import 'package:demo_chat/screens/demo_chat.dart';
import 'package:flutter/material.dart';

// const URL = 'ws://localhost:8080';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoChat(),
    );
  }
}
