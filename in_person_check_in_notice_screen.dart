import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';

class InPersonCheckInNoticeScreen extends StatelessWidget {
  const InPersonCheckInNoticeScreen({Key? key}) : super(key: key);

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
          'IN-PERSON ID\nCHECK IN',
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
            height: height * 0.60,
            decoration: const BoxDecoration(
                gradient: kMedGradient
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  TextWithIcon(
                    iconPath: "assets/icons/warning.svg",
                    text: "Notice",
                    fontWeight: FontWeight.w600,
                    fontSize: 35.0,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25.0),
                    child: Text(
                      "In-person ID Check-In at the event requires the attendee to go to Gate 9 with their ticket, photo ID and health pass to be inspected prior to gate entry."
                          "\n\n"
                          "In the event you would prefer to register your biometrics for a fast-track expedited entry, please return to the registration page.",
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
          Container(
            width: width,
            height: height * 0.25,
            decoration: const BoxDecoration(
                gradient: kDarkGradient
            ),
            child: Center(
              child: IconPillButton(
                text: "RETURN",
                iconPath: "assets/icons/return_arrow.svg",
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
