import 'package:demo_chat/screens/chat_page.dart';
import 'package:flutter/material.dart';

class DummyPage extends StatelessWidget {
  final String name;
  final String userID;
  const DummyPage({super.key, required this.name, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Navigation to Chat"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return ChartPage(
                    name: name,
                    userID: userID,
                  );
                },
              ),
            );
          },
          child: const Text("Navigate to Chat page"),
        ),
      ),
    );
  }
}
