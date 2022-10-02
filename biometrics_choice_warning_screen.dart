import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BiometricsChoiceWarningScreen extends StatelessWidget {
  const BiometricsChoiceWarningScreen({Key? key}) : super(key: key);

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
          Container(
              width: width,
              height: height * 0.85,
              decoration: const BoxDecoration(
                  gradient: kMedGradient
              )
          ),
          Column(
            children: [
              Container(
                height: height * 0.15,
                width: width,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  child: const Text(
                    "Would you like to enroll your Face or Voice for Check-In?",
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w800,
                      color: Color(kBodyTextColor),
                      fontSize: 20.0,
                    ),
                  ),
                )
              ),
              Container(
                width: width,
                height: height * 0.35,
                decoration: const BoxDecoration(
                    gradient: kDarkGradient
                ),
                child: Padding(
                  padding: EdgeInsets.all(width * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconPillButton(
                          text: "FACE",
                          iconPath: "assets/icons/face.svg",
                          onPressed: () {}
                      ),
                      IconPillButton(
                          text: "VOICE",
                          iconPath: "assets/icons/sound.svg",
                          onPressed: () {}
                      ),
                      IconPillButton(
                          text: "FACE & VOICE",
                          iconPath: "assets/icons/face_speaking.svg",
                          onPressed: () {}
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.35,
                width: width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      TextWithIcon(
                        iconPath: "assets/icons/warning.svg",
                        text: "Important!",
                        fontWeight: FontWeight.w600,
                        fontSize: 35.0,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: Text(
                            "Choosing Voice only opts your Face out of the data-base unless you choose to keep both for additional benefits*",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.w600,
                              color: Color(kBodyTextColor),
                              fontSize: 20.0,
                            ),
                          )
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
