import 'package:demo_chat/screens/chat_page.dart';
import 'package:demo_chat/screens/dummy_page.dart';
import 'package:demo_chat/utils/unique_id.dart';
import 'package:flutter/material.dart';

class DemoChat extends StatefulWidget {
  const DemoChat({super.key});

  @override
  State<DemoChat> createState() => _DemoChatState();
}

class _DemoChatState extends State<DemoChat> {
  TextEditingController userController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket Messaging"),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: Center(
        child: TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Create a user name to enter chat"),
                    content: Form(
                      key: formKey,
                      child: TextFormField(
                        controller: userController,
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return "Enter proper user name";
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if (formKey.currentState!.validate()) {
                            String name = userController.text;
                            userController.clear();
                            String userID = guidGenerator();
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return DummyPage(
                                    name: name,
                                    userID: userID,
                                  );
                                },
                              ),
                            );
                          }
                          // if (formKey.currentState!.validate()) {
                          //   String name = userController.text;
                          //   userController.clear();
                          //   String userID = guidGenerator();
                          //   Navigator.pop(context);
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) {
                          //         return ChartPage(
                          //           userID: userID,
                          //           name: name,
                          //         );
                          //       },
                          //     ),
                          //   );
                          // }
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            userController.clear();
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              String name = userController.text;
                              userController.clear();
                              String userID = guidGenerator();
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return DummyPage(
                                      name: name,
                                      userID: userID,
                                    );
                                  },
                                ),
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return

                              //       ChartPage(
                              //         name: name,
                              //         userID: userID,
                              //       );
                              //     },
                              //   ),
                              // );
                            }
                          },
                          child: const Text("Enter")),
                    ],
                  );
                },
              );
            },
            child: const Text(
              "Initiate Group Chat",
            )),
      ),
    );
  }
}
