import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/http/venue_server.dart';
import 'package:fairticketsolutions_demo_app/screens/ticket_management.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fairticketsolutions_demo_app/provider/counter.dart';
import 'package:fairticketsolutions_demo_app/screens/profile_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/tickets_screen.dart';
import '../widgets/profile_avatar.dart';
import 'dart:async';
import 'package:flutter_stable_geo_fence/flutter_stable_geo_fence.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() { return Home();
  }
}

  class Home extends State<HomeScreen> {
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

class _HomeScreenState extends StatefulWidget {
  const _HomeScreenState({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    return Geo();
  }
}

  class Geo extends State<_HomeScreenState> {

  final geoFenceService = GeoFenceService();
  final latitude = 12.938;
  final longitude = 77.6994;
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
  Fluttertoast.showToast(msg: "${geoFenceService.getCurrentLocation()}");
  if(event.status.toString() == "Status.ENTER" ) {
  Fluttertoast.showToast(
  msg: "You have Entered the Geofence!, Location : ${geoFenceService.getCurrentLocation()}");
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
  void onbuttonClick() {
  _locator();
  Fluttertoast.showToast(msg: "Status : ${geoFenceService.getStatus()}");
  }

  void _locator() async {
    Position? position = await Geolocator.getLastKnownPosition();
    setState(() {
      _position = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final StorageService storageService = Provider.of<StorageService>(context);
    final counter = Provider.of<Counter>(context, listen: false);

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 110.0,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menu'),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                await authService.signOut();
              },
            ),
            ListTile(
              title: const Text('Start Over'),
              onTap: () async {
                DialogBuilder.showLoadingDialog(
                    GlobalVariable.navState.currentContext!);
                await VenueServer.clearAllCheckIns();
                DialogBuilder.popDialog(
                    GlobalVariable.navState.currentContext!);

                await BiospFaceCaptureActions.clearFace(
                    GlobalVariable.navState.currentContext!, storageService);
                await authService.signOut();
              },
            ),
            ListTile(
              title: const Text('All Tickets'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TicketList()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: const ProfileAvatar(radius: kToolbarHeight / 2),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<Counter>(
              builder: (_, counter, __) =>
                  Text(
                    '${counter.value}',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline4,
                  ),
            ),
            const Text('Tickets'),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: GFButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TicketManagement(),
                    ),
                  );
                },
                text: "Buy Now",
                size: GFSize.LARGE,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.55,
        width: MediaQuery
            .of(context)
            .size
            .width * 0.90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              heroTag: "decrementButton",
              onPressed: () => counter.decrement(),
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
            FloatingActionButton(
              heroTag: "incrementButton",
              onPressed: () => counter.increment(),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            FloatingActionButton(
              child: Icon(Icons.navigation),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              onPressed: onbuttonClick,
            ),
          ],
        ),
      ),
    );
  }
}