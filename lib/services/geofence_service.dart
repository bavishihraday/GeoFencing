import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_stable_geo_fence/flutter_stable_geo_fence.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class FenceService extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GeofenceService();
  }
}

class GeofenceService extends State<FenceService> {

  final geoFenceService = GeoFenceService();
  final latitude = 25.4221;
  final longitude = -122.0820;
  final double radius = 500;

  static StreamSubscription? _subscription;
  static Position? _position;

  @override
  void initState() {
    super.initState();
    initGeoFenceService();
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
      startService();
    }
  }

  onclick() {
    Position? position = geoFenceService.getCurrentLocation();
    setState(() {
      _position = position; });
    initGeoFenceService();
  }

  void startService() async {
    await geoFenceService.startService(
      fenceCenterLatitude: latitude,
      fenceCenterLongitude: longitude,
      radius: radius,
    );
    _subscription = geoFenceService.geoFenceStatusListener.listen((event) {
      Fluttertoast.showToast(msg: "listener");
        if(event.status.toString() == "Status.EXIT" ) {
          Fluttertoast.showToast(
              msg: "You have Entered the Geofence!, Location : ${geoFenceService.getCurrentLocation()}");
        }
        else
        //if(event.status.toString() == "Status.EXIT") {
        Fluttertoast.showToast(msg: "You have Exited and your distance is: ${event.distance}",
            toastLength: Toast.LENGTH_LONG);
      //}
    });
  }

  @override
  void dispose() {
    geoFenceService.stopFenceService();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      );

  }
  }