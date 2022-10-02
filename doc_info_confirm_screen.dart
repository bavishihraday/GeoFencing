import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:fairticketsolutions_demo_app/screens/doc_match_confirmed_screen.dart';
import 'package:fairticketsolutions_demo_app/wrapper.dart';

class DocInfoConfirmScreen extends StatelessWidget {
  const DocInfoConfirmScreen({Key? key}) : super(key: key);

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
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.15,
            decoration: const BoxDecoration(
                gradient: kLightGradient
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(width * 0.07, 0.0, 0.0, 0.0),
              child: const Text(
                'Please confirm your data',
                style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20),
              ),
            ),
          ),
          Container(
            width: width,
            height: height * 0.40,
            decoration: const BoxDecoration(
                gradient: kMedGradient
            ),
            child: Padding(
                padding: EdgeInsets.all(width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    TextInputInfo(prefix: "Given Name(s):", info: "Alan Mark"),
                    TextInputInfo(prefix: "Last Name:", info: "Gelfand"),
                    TextInputInfo(prefix: "DOB", info: "1959-Dec-02")
                  ],
                )
            ),
          ),
          Container(
            // alignment: Alignment.centerLeft,
            width: width,
            height: height * 0.30,
            decoration: const BoxDecoration(
                gradient: kDarkGradient
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07, vertical: height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Does the information above match identical to your document?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconPillButton(
                            text: "YES",
                            iconPath: "assets/icons/checkmark.svg",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DocMatchConfirmedScreen(),
                                //should be DocumentCaptureScreen but currently not working
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: width * 0.10,
                        ),
                        IconPillButton(
                            text: "NO",
                            iconPath: "assets/icons/cross.svg",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (
                                      context) => const Wrapper(),
                                ),
                              );
                            },
                        )
                      ],
                    ),
                  ),
                  // This is just here to centre the Register button when it has text over it
                  const Text("", style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w700, fontSize: 20)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
