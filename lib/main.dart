import 'package:demo_chat/screens/demo_chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// const URL = 'ws://localhost:8080';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoChat(),
    );
  }
}

class PushNotificationService {
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  Future initialize() async {
    FirebaseMessaging.onMessage.listen((event) {
      print("got a message whilst in the foreground!");
      print("Message data: ${event.data}");

      if (event.notification != null) {
        print("Message also contained a notification: ${event.notification}");
      }
    });
  }

  Future<String?> getToken() async {
    String? token = await fcm.getToken();
    print("Token: $token");
    return token;
  }
}
