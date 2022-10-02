import 'package:fairticketsolutions_demo_app/capture_actions/workflow_actions.dart';
import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
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

    // Screen width and height so you can have percentages of screen
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false, // This prevents overflow when keyboard is brought up
      appBar: AppBar(
        leading: const SvgBackButton(),
        actions: const [SvgMenuButton()],
        backgroundColor: const Color(kHeaderBackgroundColor),
        elevation: 0,
        toolbarHeight: (height * 0.15) - statusBarHeight,
        title: const Text(
          'ACCOUNT',
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800,
              color: Color(kHeaderTextColor)
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.15,
            decoration: const BoxDecoration(
                gradient: kLightGradient
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(width * 0.07, 0.0, 0.0, 0.0),
              child: const Text(
                'Register',
                style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20),
              ),
            ),
          ),
          Container(
            width: width,
            height: height * 0.45,
            decoration: const BoxDecoration(
                gradient: kMedGradient
            ),
            child: Padding(
                padding: EdgeInsets.all(width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconTextInput(
                      labelText: "Name:*",
                      controller: fullNameController,
                      iconPath: "assets/icons/user.svg",
                      helperText: "*As it appears on document supplied",
                    ),
                    IconTextInput(
                      labelText: "Email:",
                      controller: emailController,
                      iconPath: "assets/icons/email.svg",
                    ),
                    IconTextInput(
                      labelText: "Password:",
                      controller: passwordController,
                      iconPath: "assets/icons/lock.svg",
                      isPassword: true,
                    ),
                  ],
                )
            ),
          ),
          Container(
            // alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.25,
            decoration: const BoxDecoration(
                gradient: kDarkGradient
            ),
            child: Center(
              child: IconPillButton(
                text: "NEXT",
                iconPath: "assets/icons/arrow.svg",
                onPressed: () async {
                  bool canPop = await WorkflowActions.registerWorkflow(
                      storageService,
                      fullNameController.text.trim(),
                      authService,
                      emailController.text.trim(),
                      passwordController.text,
                  );

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
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
