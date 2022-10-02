import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Screen width and height so you can have percentages of screen
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold (
      resizeToAvoidBottomInset: false, // This prevents overflow when keyboard is brought up
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: kDarkGradient
        ),
        child: Stack (
          children: [
            SvgPicture.asset(
              "assets/icons/chevron_top.svg",
              color: const Color(kHeaderBackgroundColor),
              width: width, // This aligns it to the top for some reason...
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.20, vertical: width * 0.25),
              child: SvgPicture.asset(
                "assets/icons/idbase_full_icon.svg",
                semanticsLabel: "IdBase Logo",
                width: width * 0.60,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                "assets/icons/idbase_partial_icon.svg",
                width: width,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: width * 0.40),
                child: StartPillButton(
                  icon: Icons.keyboard_arrow_right,
                  text: "START",
                    onPressed: () {
                      Navigator.pushNamed(context, '/wrapper');
                    }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Version of PillButton what is modified to be wider and use an Icon instead of an SVG (this is only used here)
class StartPillButton extends StatelessWidget {
  const StartPillButton({Key? key, required this.icon, required this.text, required this.onPressed}) : super(key: key);

  final IconData icon;
  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), // Disable press animation
      shape: MaterialStateProperty.all<StadiumBorder>(
          const StadiumBorder()
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(kSelectedButton);
            } else {
              return const Color(kUnselectedButton);
            }
          }
      ),
      foregroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(kSelectedTextColor);
            } else {
              return const Color(kBodyTextColor);
            }
          }
      ),
      elevation: MaterialStateProperty.all<double>(0.0),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 60.0)
      ),
    );

    ElevatedButton elevatedButton = ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30.0,
          ),
          Padding(
            // Padding is here to allow for the icon to be slightly larger
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              text,
              style: const TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
      style: buttonStyle,
      onPressed: onPressed,
    );

    return elevatedButton;
  }
}