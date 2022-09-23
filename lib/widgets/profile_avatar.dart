import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../provider/profile.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({Key? key, required this.radius}) : super(key: key);
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Profile>.value(
      value: profileProvider,
      child: _ProfileAvatarState(radius: radius),
    );
  }
}

class _ProfileAvatarState extends StatelessWidget {
  const _ProfileAvatarState({Key? key, required this.radius}) : super(key: key);
  final double radius;

  @override
  Widget build(BuildContext context) {
    final Profile profileProvider = Provider.of<Profile>(context, listen: true); // Rebuilds this state when avatar is changed
    final Uint8List? imageBlob = profileProvider.getAvatar();

    if (imageBlob != null) {
      return GFAvatar(
        backgroundImage: Image.memory(
          imageBlob,
          fit: BoxFit.contain,
        ).image,
        backgroundColor: Colors.grey,
        radius: radius,
        shape: GFAvatarShape.circle,
      );
    }
    else {
      // This is just a fallback if no avatar is present or has not been yet registered
      return GFAvatar(
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: radius,
        ),
        backgroundColor: Colors.grey,
        radius: radius,
        shape: GFAvatarShape.circle,
      );
    }
  }
}
