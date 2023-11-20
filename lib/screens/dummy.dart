import 'dart:convert';

import 'package:demo_chat/utils/msg_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class ChatModel extends ChangeNotifier {
  final IOWebSocketChannel channel =
      IOWebSocketChannel.connect('ws://localhost:8080');
  List<MessageModel> _messages = [];

  List<MessageModel> get messages => _messages;

  void sendMessage(String message, String type, String sendName) {
    final msgModel = MessageModel(
        message: message, type: type, sendName: sendName, userID: '');
    _messages.add(msgModel);

    final jsonMessage = jsonEncode({
      "type": msgModel.type,
      "msg": msgModel.message,
      "senderName": msgModel.sendName,
    });

    channel.sink.add(jsonMessage);
    notifyListeners();
  }

  void receiveMessage(String jsonString) {
    final Map<String, dynamic> messageData = jsonDecode(jsonString);
    final msgModel = MessageModel(
        message: messageData['msg'],
        type: messageData['type'],
        sendName: messageData['senderName'],
        userID: '');
    _messages.add(msgModel);
    notifyListeners();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}

class ChatScreen extends StatelessWidget {
  final TextEditingController _textController = TextEditingController();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ChatModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: model.messages.length,
                itemBuilder: (context, index) {
                  final message = model.messages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('${message.sendName}: ${message.message}'),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration:
                        const InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    model.sendMessage(
                        _textController.text, "ownMsg", "YourName");
                    _textController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
