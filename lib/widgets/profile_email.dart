import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../provider/profile.dart';

class ProfileEmail extends StatelessWidget {
  const ProfileEmail({Key? key, required this.style}) : super(key: key);
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Profile>.value(
      value: profileProvider,
      child: _ProfileEmailState(style: style),
    );
  }
}

class _ProfileEmailState extends StatelessWidget {
  const _ProfileEmailState({Key? key, required this.style}) : super(key: key);
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final Profile profileProvider = Provider.of<Profile>(context, listen: true); // Rebuilds this state when email is changed

    String? email = profileProvider.getEmail();

    if (email == null || email == "") {
      email = "Email not found!";
    }

    return Text(
      email,
      style: style,
      textAlign: TextAlign.center,
    );
  }
}
