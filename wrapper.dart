import 'package:fairticketsolutions_demo_app/screens/home_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/login_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/ticket_confirm_screen.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'models/user_model.dart';
import 'package:fairticketsolutions_demo_app/provider/profile.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final storageService = Provider.of<StorageService>(context);

    return StreamBuilder<User?>(
      stream: authService.user,
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;

          if (user == null) {
            return const LoginScreen();
          }
          else {
            storageService.setUid();
            profileProvider.setProfileFromUser(user);

            // This loads in afterwards
            storageService
                .getBlob(context, "avatar.jpeg")
                .then((avatarBlob) => {profileProvider.setAvatar(avatarBlob)});

            return const HomeScreen();
          }
        }
        else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
