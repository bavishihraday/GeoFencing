import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/biosp_voice_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/screens/enroll_choice_screen.dart';


class IdConfirmedScreen extends StatelessWidget {
  const IdConfirmedScreen({Key? key}) : super(key: key);

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
          'BIOMETRICS FAST\nTRACK CHECK-IN',
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800,
              color: Color(kHeaderTextColor)
          ),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              // alignment: Alignment.centerLeft,
              width: width,
              height: height * 0.35,
              decoration: const BoxDecoration(
                  gradient: kDarkGradient
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              "assets/icons/chevron_bottom.svg",
              color: const Color(kHeaderBackgroundColor),
              width: width,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // Sized box to center at the bottom of the screen should be used here, but it stretches the button for some reason
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.12),
              child: CircleIconButton(
                iconPath: "assets/icons/checkmark.svg",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnrollChoiceScreen(),
                      //should be DocumentCaptureScreen but currently not working
                    ),
                  );
                },
                semanticsLabel: "Confirm Button",
                isInverted: true,
              ),
            ),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.30,
                decoration: const BoxDecoration(
                    gradient: kMedGradient
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: SvgPicture.asset(
                        "assets/icons/user.svg",
                        semanticsLabel: "User Icon",
                        color: const Color(kBodyTextColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            style: TextStyle(
                              fontFamily: "OpenSans",
                              fontSize: 30.0,
                              color: Color(kBodyTextColor),
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(text: "Your identity is now\n"),
                              TextSpan(
                                text: "Confirmed",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 40.0
                                ),
                              )
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: width,
                height: height * 0.20,
                decoration: const BoxDecoration(
                  gradient: kLightGradient
                ),
                child: const Center(
                  child: Text(
                    "Alan Mark Gelfand",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 30.0,
                      color: Color(kBodyTextColor),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
