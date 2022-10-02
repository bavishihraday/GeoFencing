import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';
import 'package:flutter_stable_geo_fence/flutter_stable_geo_fence.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fairticketsolutions_demo_app/screens/voice_id_match_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/face_id_match_screen.dart';




class BiometricsChoiceScreen extends StatefulWidget {
  const BiometricsChoiceScreen({Key? key}) : super(key: key);
  //final String title;

  @override
  State<StatefulWidget> createState() {
    return BiometricsScreenWithGeoFence();
  }
}

class BiometricsScreenWithGeoFence extends State<BiometricsChoiceScreen> {

  final geoFenceService = GeoFenceService();
  final latitude = 12.938;
  final longitude = 77.6994;
  final double radius = 500;

  static StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    initGeoFenceService();
    Fluttertoast.showToast(msg: "Geofence Service Starting");

  }

  void initGeoFenceService() async{
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        startService();
      } else {
        debugPrint("Location Permission should be granted to use GeoFenceSerive");
      }

    } else {
      debugPrint("Location Permission Given");
      Fluttertoast.showToast(msg: "Location Permission Given");
      startService();
    }
  }

  void startService() async {
    await geoFenceService.startService(
      fenceCenterLatitude: latitude,
      fenceCenterLongitude: longitude,
      radius: radius,
    );
    _subscription = geoFenceService.geoFenceStatusListener.listen((event) {
      if(geoFenceService.getCurrentLocation() != Null)
      Fluttertoast.showToast(msg: "${geoFenceService.getCurrentLocation()}");

      if(event.status.toString() == "Status.ENTER" ) {
        Fluttertoast.showToast(msg: "You have Entered the Geofence!");
      }
      else
      if(event.status.toString() == "Status.EXIT") {
        Fluttertoast.showToast(msg: "You have Exited and your distance is: ${event.distance}",
            toastLength: Toast.LENGTH_LONG);
      }
    });
  }

  @override
  void dispose() {
    geoFenceService.stopFenceService();
    _subscription?.cancel();
  }

    @override
    Widget build(BuildContext context) {
      // Screen width and height so you can have percentages of screen
      final double width = MediaQuery
          .of(context)
          .size
          .width;
      final double height = MediaQuery
          .of(context)
          .size
          .height;
      final double statusBarHeight = MediaQuery
          .of(context)
          .viewPadding
          .top;

      return Scaffold(
        resizeToAvoidBottomInset: false,
        // This prevents overflow when keyboard is brought up
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
                        "How would you like to Check-In?",
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconPillButton(
                            text: "FACE",
                            iconPath: "assets/icons/face.svg",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FaceIdMatchScreen(),
                                //should be DocumentCaptureScreen but currently not working
                              ),
                            );
                          },
                        ),
                        IconPillButton(
                            text: "VOICE",
                            iconPath: "assets/icons/sound.svg",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VoiceIdMatchScreen(),
                                //should be DocumentCaptureScreen but currently not working
                              ),
                            );
                          },
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

