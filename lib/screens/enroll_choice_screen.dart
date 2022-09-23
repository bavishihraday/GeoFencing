import 'package:fairticketsolutions_demo_app/models/biosp_enums.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';

class EnrollChoiceScreen extends StatelessWidget {
  const EnrollChoiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Would you like to enroll Face or Voice?",
              style: Theme.of(context).textTheme.headline3,
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GFButton(
                  onPressed: () { Navigator.pop(context, MatchType.voice); },
                  child: const Text("Enroll Voice"),
                ),
                const SizedBox(width: 10),
                GFButton(
                  onPressed: () { Navigator.pop(context, MatchType.face); },
                  child: const Text("Enroll Face"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
