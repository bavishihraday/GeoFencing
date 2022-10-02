import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/http/venue_server.dart';
import 'package:fairticketsolutions_demo_app/screens/ticket_confirm_screen.dart';
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
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
    final authService = Provider.of<AuthService>(context);
    final StorageService storageService = Provider.of<StorageService>(context);
    final Counter counter = Provider.of<Counter>(context, listen: false);

    // Screen width and height so you can have percentages of screen
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false, // This prevents overflow when keyboard is brought up
      endDrawer: Drawer(
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
                DialogBuilder.showLoadingDialog(GlobalVariable.navState.currentContext!);
                await VenueServer.clearAllCheckIns();
                DialogBuilder.popDialog(GlobalVariable.navState.currentContext!);

                await BiospFaceCaptureActions.clearFace(GlobalVariable.navState.currentContext!, storageService);
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
        // actions: <Widget>[
        //   Container(
        //     padding: const EdgeInsets.all(4.0),
        //     child: GestureDetector(
        //       onTap: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const ProfileScreen(),
        //           ),
        //         );
        //       },
        //       child: const ProfileAvatar(radius: kToolbarHeight / 2),
        //     ),
        //   )
        // ],
        leading: const SvgBackButton(),
        actions: const [SvgMenuButton()],
        backgroundColor: const Color(kHeaderBackgroundColor),
        elevation: 0,
        toolbarHeight: (height * 0.15) - statusBarHeight,
        title: const Text(
          'TICKET PURCHASE',
          style: TextStyle(
              fontFamily: "OpenSans",
              fontWeight: FontWeight.w800,
              color: Color(kHeaderTextColor)
          ),
        ),
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Consumer<Counter>(
      //         builder: (_, counter, __) => Text(
      //           '${counter.value}',
      //           style: Theme.of(context).textTheme.headline4,
      //         ),
      //       ),
      //       const Text('Tickets'),
      //       Container(
      //         padding: const EdgeInsets.all(20.0),
      //         child: GFButton(
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => const TicketManagement(),
      //               ),
      //             );
      //           },
      //           text: "Buy Now",
      //           size: GFSize.LARGE,
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      // floatingActionButton: SizedBox(
      //   height: MediaQuery.of(context).size.height * 0.55,
      //   width: MediaQuery.of(context).size.width * 0.90,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: [
      //       FloatingActionButton(
      //         heroTag: "decrementButton",
      //         onPressed: () => counter.decrement(),
      //         tooltip: 'Decrement',
      //         child: const Icon(Icons.remove),
      //       ),
      //       FloatingActionButton(
      //         heroTag: "incrementButton",
      //         onPressed: () => counter.increment(),
      //         tooltip: 'Increment',
      //         child: const Icon(Icons.add),
      //       ),
      //     ],
      //   ),
      // ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Number of\ntickets",
                    style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                  IncrementCounter()
                ],
              ),
            ),
          ),
          Container(
            width: width,
            height: height * 0.38,
            decoration: const BoxDecoration(
              gradient: kDarkGradient
            ),
            child: Center(
              child: IconPillButton(
                text: "BUY",
                iconPath: "assets/icons/shopping_bag.svg",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TicketConfirmScreen(),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
