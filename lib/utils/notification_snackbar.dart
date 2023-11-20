import 'package:flutter/material.dart';

notificationSnackbar(BuildContext? context, String notificationMsg) {
  return ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 1500),
      backgroundColor: Colors.blueGrey[400],
      content: Text(
        notificationMsg,
        style: TextStyle(color: Colors.blueGrey[100]),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.76,
          right: 20,
          left: 20),
    ),
  );
}
