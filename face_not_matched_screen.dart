import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FaceNotMatchedScreen extends StatelessWidget {
  const FaceNotMatchedScreen({Key? key}) : super(key: key);

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
          'WELCOME TO\nTONIGHT\'S EVENT!',
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
              color: const Color(kBodyTextColor),
              width: width,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            // Sized box to center at the bottom of the screen should be used here, but it stretches the button for some reason
            child: Padding(
              padding: EdgeInsets.only(bottom: height * 0.12),
              child: CircleIconButton(
                iconPath: "assets/icons/cross.svg",
                onPressed: () {},
                semanticsLabel: "Cancel Button",
              ),
            ),
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.50,
                decoration: const BoxDecoration(
                    gradient: kMedGradient
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: SvgPicture.asset(
                          "assets/icons/sad_face.svg",
                          semanticsLabel: "Face Icon",
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
                              TextSpan(text: "Identity\n"),
                              TextSpan(
                                text: "Not Verified\n\n",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 35.0
                                ),
                              ),
                            ]
                          ),
                        )
                      ),
                      IconPillButton(
                        text: "TRY AGAIN",
                        iconPath: "assets/icons/return_arrow.svg",
                        onPressed: () {}
                      )
                    ],
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
