import 'package:fairticketsolutions_demo_app/screens/login_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/profile_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/register_screen.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/services/geofence_service.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:fairticketsolutions_demo_app/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_stable_geo_fence/flutter_stable_geo_fence.dart';
//import 'dart:async';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),
        ),
        Provider<GeofenceService>(
          create: (_) => GeofenceService(),
        )
      ],
      child: MaterialApp(
        title: 'Demo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const Wrapper(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
        navigatorKey: GlobalVariable.navState, // This enables getting an up to date context from anywhere in the application

      ),
    );
  }
 }


