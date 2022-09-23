import 'package:fairticketsolutions_demo_app/capture_actions/workflow_actions.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();
    final authService = Provider.of<AuthService>(context);
    final StorageService storageService = Provider.of<StorageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                  labelText: "Full Name (Given name(s) Lastname)"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              bool canPop = await WorkflowActions.registerWorkflow(
                  storageService,
                  fullNameController.text.trim(),
                  authService,
                  emailController.text.trim(),
                  passwordController.text);

              // This screen is popped automatically when user is created
              if (!canPop) {
                Fluttertoast.showToast(
                  msg: "Something went wrong with registration!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            },
            child: const Text('Register'),
          )
        ],
      ),
    );
  }
}
