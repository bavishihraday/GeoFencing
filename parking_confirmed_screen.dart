import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fairticketsolutions_demo_app/screens/upgrade_seats_screen.dart';


class ParkingConfirmedScreen extends StatelessWidget {
  const ParkingConfirmedScreen({Key? key}) : super(key: key);

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
          "WELCOME TO\nTONIGHT'S EVENT!",
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
                gradient: kDarkGradient
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: height * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: SvgPicture.asset(
                      "assets/icons/car.svg",
                      semanticsLabel: "Car Icon",
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
                          TextSpan(text: "Parking\n"),
                          TextSpan(
                            text: "Confirmed",
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 35.0
                            ),
                          )
                        ]
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Image.asset(
                      "assets/images/sample_qr_code.png",
                      height: width * 0.45,
                      width: width * 0.45,
                    ),
                  ),
                  const Text(
                    "Please present to parking lot gate attendant for entry",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 20.0,
                      color: Color(kBodyTextColor),
                      fontWeight: FontWeight.w800,
                    ),
                  )
                ],
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
                      builder: (context) => const UpgradeSeatsScreen(),
                      //should be DocumentCaptureScreen but currently not working
                    ),
                  );
                },
                semanticsLabel: "Confirm Button",
                isInverted: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
