import 'package:flutter/material.dart';

// Containing class for quick dialog creation
class DialogBuilder {
  // Just to show quick info to the user, more complex dialogs you have to make yourself
  static void showInfoDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              Container(
                  margin: const EdgeInsets.only(left: 7), child: const Text("Loading...")),
            ],
          ),
        );
      },
    );
  }

  // Quick function to pop dialog
  static void popDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}
