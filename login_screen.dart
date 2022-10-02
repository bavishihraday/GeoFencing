import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// TODO: Add form checking like the buy screen has
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final authService = Provider.of<AuthService>(context);

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
        // mainAxisAlignment: MainAxisAlignment.center,
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
                'Already have an account?',
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
                    labelText: "Email:",
                    controller: emailController,
                    iconPath: "assets/icons/email.svg"
                  ),
                  IconTextInput(
                    labelText: "Password:",
                    controller: passwordController,
                    iconPath: "assets/icons/lock.svg",
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconPillButton(
                      text: "LOGIN",
                      iconPath: "assets/icons/login.svg",
                      onPressed: () {
                        authService.signInWithEmailAndPassword(emailController.text.trim(), passwordController.text);
                      },
                    )
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'OR',
                  style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w700, fontSize: 20),
                ),
                IconPillButton(
                    text: "REGISTER",
                    iconPath: "assets/icons/pencil.svg",
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    }
                ),
                // This is just here to centre the Register button when it has text over it
                const Text("", style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w700, fontSize: 20)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
