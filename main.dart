import 'package:fairticketsolutions_demo_app/screens/login_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/profile_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/register_screen.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:fairticketsolutions_demo_app/wrapper.dart';
import 'package:fairticketsolutions_demo_app/screens/start_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/ticket_confirm_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/id_required_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/id_confirmed_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/doc_info_confirm_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/document_capture_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/face_capture_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        )
      ],
      child: MaterialApp(
        title: 'Demo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const StartScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/wrapper': (context) => const Wrapper(),
          '/ticketPurchase': (context) => const HomeScreen(),
          '/ticketConfirmation': (context) => const TicketConfirmScreen(),
          '/idReq': (context) => const IdRequiredScreen(),
          '/documentCapture': (context) => const DocumentCaptureScreen(),
          'docInfoConfirm': (context) => const DocInfoConfirmScreen(),
          '/idConfirm': (context) => const IdConfirmedScreen(),
          //'/faceCaptureScreen': (context) => const FaceCaptureScreen(),

        },
        navigatorKey: GlobalVariable.navState, // This enables getting an up to date context from anywhere in the application
      ),
    );
  }
}
