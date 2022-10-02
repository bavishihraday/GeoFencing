import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/http/venue_server.dart';
import 'package:fairticketsolutions_demo_app/screens/parking_confirmed_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/upgrade_seats_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/ticket_management.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fairticketsolutions_demo_app/provider/counter.dart';
import 'package:fairticketsolutions_demo_app/screens/tickets_screen.dart';

class ParkingAvailableScreen extends StatelessWidget {
  const ParkingAvailableScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider<Counter>.value(
        value: counterProvider,
        child: const _HomeScreenState(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class _HomeScreenState extends StatelessWidget {
  const _HomeScreenState({Key? key, required this.title}) : super(key: key);
  final String title;

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
                'Parking available',
                style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.10,
            decoration: const BoxDecoration(
                gradient: kMedGradient
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWithIcon(
                    text: "Lot 313",
                    iconPath: "assets/icons/location.svg",
                    fontWeight: FontWeight.w600,
                  ),
                  PillButton(text: "BUY NOW", onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParkingConfirmedScreen(),
                        //should be DocumentCaptureScreen but currently not working
                      ),
                    );
                  },
                  )
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.10,
            decoration: const BoxDecoration(
                gradient: kMedLightGradient
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWithIcon(
                    text: "Lot 457",
                    iconPath: "assets/icons/location.svg",
                    fontWeight: FontWeight.w600,
                  ),
                  PillButton(text: "BUY NOW", onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParkingConfirmedScreen(),
                        //should be DocumentCaptureScreen but currently not working
                      ),
                    );
                  },
                  )
                ],
              ),
            ),
          ),
          Container(
            width: width,
            height: height * 0.50,
            decoration: const BoxDecoration(
                gradient: kDarkGradient
            ),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.10,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: width * 0.07),
                    child: const Text(
                      "Your Credit Card on file will be automatically charged",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 20.0),
                    ),
                  ),
                ),
                Image.asset(
                  "assets/images/sample_arena_map.png",
                  width: width,
                  height: height * 0.30,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: height * 0.10,
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: width * 0.07),
                    child: TransparentPillButton(text: "NO, THANKS", onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpgradeSeatsScreen(),
                          //should be DocumentCaptureScreen but currently not working
                        ),
                      );
                    },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
