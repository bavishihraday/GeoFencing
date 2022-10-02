import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fairticketsolutions_demo_app/screens/document_capture_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/doc_info_confirm_screen.dart';


class IdRequiredScreen extends StatelessWidget {
  const IdRequiredScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'ID REQUIRED',
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
            width: width,
            height: height * 0.34,
            decoration: const BoxDecoration(
              gradient: kMedGradient
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const TextWithIcon(
                  iconPath: "assets/icons/warning.svg",
                  text: "Important!",
                  fontWeight: FontWeight.w600,
                  fontSize: 35.0,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontFamily: "OpenSans",
                        fontSize: 20.0,
                        color: Color(kBodyTextColor),
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(text: "ID is required", style: TextStyle(fontWeight: FontWeight.w800)),
                        TextSpan(text: " to enter this\nevent")
                      ]
                    ),
                  ),
                )
              ],
            ),
          ),
          WidthSpanButton(
              text: "Skip the line Biometric\nFast Track Check-In",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DocInfoConfirmScreen(),
                    //should be DocumentCaptureScreen but currently not working
                  ),
                );
              },
              width: width,
              height: height * 0.13
          ),
          WidthSpanButton(
              text: "In-Person ID Check at event",
              onPressed: () {},
              width: width,
              height: height * 0.13
          ),
          Container(
            width: width,
            height: height * 0.25,
            decoration: const BoxDecoration(
              gradient: kDarkGradient
            ),
          )
        ],
      ),
    );
  }
}
