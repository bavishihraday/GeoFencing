import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fairticketsolutions_demo_app/screens/health_req_confirmed_screen.dart';


class FaceThankYouScreen extends StatelessWidget {
  const FaceThankYouScreen({Key? key}) : super(key: key);

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
              height: height * 0.38,
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
                      builder: (context) => const HealthReqConfirmedScreen(),
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
                height: height * 0.48,
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
                          "assets/icons/face.svg",
                          semanticsLabel: "Face Icon",
                          color: const Color(kBodyTextColor),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Thank you",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.w800,
                            color: Color(kBodyTextColor),
                            fontSize: 40.0,
                          ),
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Your Face will now be used as your primary way of checking in when you receive the check-in notification at any event you attend",
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
