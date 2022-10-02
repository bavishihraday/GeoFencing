import 'package:fairticketsolutions_demo_app/models/biosp_enums.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:fairticketsolutions_demo_app/screens/face_thank_you_screen.dart';
import 'package:fairticketsolutions_demo_app/screens/voice_enroll_confirm_screen.dart';



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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VoiceEnrollConfirmScreen(),
                        //should be DocumentCaptureScreen but currently not working
                      ),
                    );
                  },
                  child: const Text("Enroll Voice"),
                ),
                const SizedBox(width: 10),
                GFButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FaceThankYouScreen(),
                        //should be DocumentCaptureScreen but currently not working
                      ),
                    );
                  },
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
