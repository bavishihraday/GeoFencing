import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fairticketsolutions_demo_app/screens/ticket_qr_code_screen.dart';

class UpgradeSeatsScreen extends StatelessWidget {
  const UpgradeSeatsScreen({Key? key}) : super(key: key);

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
                'Upgrade seats?',
                style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20.0),
              ),
            ),
          ),
          Image.asset(
            "assets/images/sample_seat_view.png",
            width: width,
            height: height * 0.50,
            fit: BoxFit.cover,
          ),
          Container(
            width: width,
            height: height * 0.20,
            decoration: const BoxDecoration(
                gradient: kDarkGradient
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(width * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconPillButton(
                      text: "BUY NOW",
                      iconPath: "assets/icons/shopping_bag.svg",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TicketQrCodeScreen(),
                            //should be DocumentCaptureScreen but currently not working
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    TransparentPillButton(
                      text: "NO, THANKS",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TicketQrCodeScreen(),
                            //should be DocumentCaptureScreen but currently not working
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
