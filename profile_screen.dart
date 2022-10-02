import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/biosp_voice_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:fairticketsolutions_demo_app/utils/qr_scan.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import '../widgets/profile_avatar.dart';
import 'package:fairticketsolutions_demo_app/widgets/profile_email.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final StorageService storageService = Provider.of<StorageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ProfileAvatar(radius: 100),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: ProfileEmail(style: Theme.of(context).textTheme.headline5),
            ),
            const SizedBox(
              height: 60,
            ),
            GFButton(
              onPressed: () async {
                await BiospFaceCaptureActions.enrollFromFace(context, storageService, "Enroll Face");
              },
              text: "Register Face",
              shape: GFButtonShape.square,
              size: GFSize.LARGE,
            ),
            GFButton(
              onPressed: () async {
                await BiospFaceCaptureActions.clearFace(context, storageService);
              },
              text: "Clear Avatar",
              shape: GFButtonShape.square,
              size: GFSize.LARGE,
            ),
            GFButton(
              onPressed: () async {
                bool isVerified = await QrScan.verifyQr();

                DialogBuilder.showInfoDialog(context, "Verify QR Code", isVerified ? "Verified!" : "No QR Code");
              },
              text: "Verify QR Code",
              shape: GFButtonShape.square,
              size: GFSize.LARGE,
            ),
            GFButton(
              onPressed: () async {
                await VoiceCaptureActions.enrollFromVoice(context, "Enroll Voice", true);
              },
              text: "Register Voice",
              shape: GFButtonShape.square,
              size: GFSize.LARGE,
            ),
            // GFButton(
            //   onPressed: () async {
            //     await VoiceCaptureActions.verifyVoice(context, 10.0);
            //   },
            //   text: "Test Voice Matching",
            //   shape: GFButtonShape.square,
            //   size: GFSize.LARGE,
            // ),
            // GFButton(
            //   onPressed: () async {
            //     DocumentReaderResults? result = await DocCaptureActions.performDocCapture(context);
            //
            //     DialogBuilder.showInfoDialog(context, "Doc Capture", "${DocUtils.checkIfDrivingLicense(result?.documentType[0]?.dType)}");
            //   },
            //   text: "Test Doc Capture",
            //   shape: GFButtonShape.square,
            //   size: GFSize.LARGE,
            // ),
          ],
        ),
      ),
    );
  }
}
