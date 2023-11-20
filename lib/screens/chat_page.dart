import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:html' as html;
import 'package:demo_chat/utils/constants.dart';
import 'package:demo_chat/utils/msg_model.dart';
import 'package:demo_chat/utils/notification_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

String connectionStatus = '';

class ChartPage extends StatefulWidget {
  final String name;
  final String userID;
  // final WebSocketChannel channel;
  const ChartPage({
    super.key,
    required this.name,
    required this.userID,
  });

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  TextEditingController messageTextController = TextEditingController();
  String messageText = "";
  FocusNode msgFocusNode = FocusNode();
  late WebSocketChannel channel;
  late StreamController _streamController;
  bool _reconnecting = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // late Stream stream;
  late Future<WebSocket> webSocket;
  @override
  void initState() {
    super.initState();
    _streamController = StreamController.broadcast(
      sync: true,
    );
    connect();

    // channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
    // channel = HtmlWebSocketChannel.connect(
    //   'ws://localhost:8080',
    // );

    // stream = channel.stream.asBroadcastStream();
    // initializeWebSocket();
    // connect();
    // print();
  }

  // getPreviousMsgs() {
  //   if (listMsg.isNotEmpty) {
  //     for (var element in listMsg) {
  //       _streamController.add(utf8.encode(element));
  //     }
  //   }
  // }
  // Future<void> initializeWebSocket() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('http://localhost:8080/socket-initialization'),
  //       headers: {'HeaderName': 'HeaderValue'}, // Add your custom headers here
  //     );

  //     if (response.statusCode == 200) {
  //       debugPrint(response.body);

  //       final webSocketUrl = json.decode(response.body)['webSocketUrl'];

  //       // Connect to the WebSocket using the obtained URL
  //       if (!_reconnecting) {
  //         _reconnecting = true;
  //         channel = WebSocketChannel.connect(Uri.parse(
  //           webSocketUrl,
  //         ));

  //         channel.stream.listen(
  //           (event) {
  //             _streamController.add(event);
  //           },
  //           onDone: () async {
  //             _reconnecting = true;
  //             notificationSnackbar(_scaffoldKey.currentContext,
  //                 "You got disconnected\n\nTry after sometimes");
  //             await _delayedReconnect();
  //           },
  //           onError: (error) async {
  //             // notificationSnackbar(context, error.toString());
  //             debugPrint("Error in websocket connection: + $error");
  //             await _delayedReconnect();
  //           },
  //           cancelOnError: true,
  //         );
  //         // getPreviousMsgs();
  //       }

  //       // getPreviousMsgs(); // If you have logic to get previous messages
  //     } else {
  //       print('Failed to initialize WebSocket: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error during WebSocket setup: $e');
  //     await _delayedReconnect();
  //   }
  // }

  void connect() {
    if (!_reconnecting) {
      _reconnecting = true;
      webSocket = WebSocket.connect("ws://localhost:8080",
          headers: {"sdfasd": "dfasd"});

      // webSocket = WebSocket.connect(
      //   "ws://localhost:8080",
      //   headers: {"headers": "Header added"},
      // );

      // channel = WebSocketChannel.connect(Uri.parse(
      //   'ws://localhost:8080',
      // ));

      // channel.stream.listen(
      //   (event) {
      //     _streamController.add(event);
      //   },
      //   onDone: () async {
      //     _reconnecting = true;
      //     notificationSnackbar(_scaffoldKey.currentContext,
      //         "You got disconnected\n\nTry after sometimes");
      //     await _delayedReconnect();
      //   },
      //   onError: (error) async {
      //     // notificationSnackbar(context, error.toString());
      //     debugPrint("Error in websocket connection: + $error");
      //     await _delayedReconnect();
      //   },
      //   cancelOnError: true,
      // );
      // getPreviousMsgs();
    }
  }

  Future<void> _delayedReconnect() async {
    await Future.delayed(const Duration(seconds: 4));
    _reconnecting = false;
    // Set the flag to false before initiating the next reconnection attempt
    connect();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  void sendMsg(String msg, String senderName) {
    MessageModel msgModel = MessageModel(
        message: msg,
        type: "sendNewMessage",
        sendName: senderName,
        userID: widget.userID);

    Map<String, dynamic> websocketMessage = {
      "type": msgModel.type,
      "msg": msgModel.message,
      "senderName": msgModel.sendName,
      "userID": msgModel.userID,
    };
    listMsg.add(jsonEncode(websocketMessage));

    final jsonWebSocketMsg = jsonEncode(websocketMessage);
    // final jsonMessage = websocketMessage.toString();

    channel.sink.add(jsonWebSocketMsg);

    // channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Chat Page"),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MessagesStream(
                // stream: stream,
                channel: channel,
                name: widget.name,
                userID: widget.userID,
                streamController: _streamController,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: kMessageContainerDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                focusNode: msgFocusNode,
                autofocus: true,
                controller: messageTextController,
                onChanged: (value) {
                  messageText = value;
                },
                onSubmitted: (value) {
                  String msg = messageTextController.text;
                  if (msg.isNotEmpty) {
                    sendMsg(msg, widget.name);
                    messageTextController.clear();
                  }
                },
                decoration: kMessageTextFieldDecoration,
              ),
            ),
            FloatingActionButton(
              child: const Icon(Icons.send),
              onPressed: () {
                String msg = messageTextController.text;
                if (msg.isNotEmpty) {
                  sendMsg(msg, widget.name);
                  messageTextController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatefulWidget {
  final WebSocketChannel channel;
  final StreamController streamController;
  // final Stream stream;
  final String name;
  final String userID;
  const MessagesStream({
    super.key,
    required this.channel,
    required this.name,
    required this.userID,
    // required this.stream,
    required this.streamController,
  });

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  late ScrollController _scrollController;

  bool? isWebsocketActive;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // Future<void> reconnect() async {
  //   await Future.delayed(const Duration(seconds: 4));
  //   setState(() {
  //     widget.channel = WebSocketChannel.connect(
  //       Uri.parse("ws://localhost:8080"),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.streamController.stream,
      builder: (context, snapshot) {
        isWebsocketActive = false;
        if (!snapshot.hasData || snapshot.data == null) {
          if (messageBubbles.isEmpty) {
            return const Center(
              child: Text("You can chat"),
            );
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          });
          return ListView.builder(
            controller: _scrollController,
            reverse: false,
            shrinkWrap: true,
            physics: const RangeMaintainingScrollPhysics(),
            itemCount: messageBubbles.length,
            itemBuilder: (context, index) {
              return Container(
                child: messageBubbles[index],
              );
            },
          );
        } else if (snapshot.hasData && snapshot.data is! String) {
          String msgJson = utf8.decode(snapshot.data);
          final Map<String, dynamic> messageData = json.decode(msgJson);
          final String messageText = messageData["msg"];
          final String messageSender = messageData["senderName"];
          final String messageUserID = messageData["userID"];

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: widget.userID == messageUserID,
          );
          messageBubbles.add(messageBubble);

          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          });

          return ListView.builder(
            controller: _scrollController,
            reverse: false,
            shrinkWrap: true,
            physics: const RangeMaintainingScrollPhysics(),
            itemCount: messageBubbles.length,
            itemBuilder: (context, index) {
              return Container(
                child: messageBubbles[index],
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.sender, this.text, this.isMe});

  final String? sender;
  final String? text;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender!,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe!
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe! ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text!,
                style: TextStyle(
                  color: isMe! ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
