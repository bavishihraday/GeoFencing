import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fairticketsolutions_demo_app/screens/id_required_screen.dart';


class TicketConfirmScreen extends StatelessWidget {
  const TicketConfirmScreen({Key? key}) : super(key: key);

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
          'TICKET\nCONFIRMATION',
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
                gradient: kMedLightGradient
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(width * 0.07, 0.0, 0.0, 0.0),
              child: const Text(
                'ABC Event',
                style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 40),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.17,
            decoration: const BoxDecoration(
                gradient: kMedGradient
            ),
            child: Padding(
              padding: EdgeInsets.all(width * 0.07),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TextWithIcon(
                    text: "Sunday, January 1",
                    iconPath: "assets/icons/calendar.svg",
                    fontWeight: FontWeight.w800,
                  ),
                  TextWithIcon(
                    text: "2023 XYZ Arena",
                    iconPath: "assets/icons/location.svg",
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
          ),
          Container(
            width: width,
            height: height * 0.15,
            decoration: const BoxDecoration(
                gradient: kMedDarkGradient
            ),
            child: Padding(
              padding: EdgeInsets.all(width * 0.07),
              child: const TextWithIcon(
                text: "Doors open at 8:00 pm",
                iconPath: "assets/icons/clock.svg",
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.17,
            decoration: const BoxDecoration(
                gradient: kMedGradient
            ),
            child: Padding(
              padding: EdgeInsets.all(width * 0.07),
              child: const Text(
                'Section 103,\nRow 17\nSeat 12',
                style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 20.0),
              ),
            ),
          ),
          Container(
            width: width,
            height: height * 0.21,
            decoration: const BoxDecoration(
                gradient: kDarkGradient
            ),
            child: Center(
              child: CircleIconButton(
                iconPath: "assets/icons/checkmark.svg",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IdRequiredScreen(),
                    ),
                  );
                },
                semanticsLabel: "Confirm Button",
              ),
            ),
          )
        ],
      ),
    );
  }
}
