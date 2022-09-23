import 'dart:typed_data';
import 'package:fairticketsolutions_demo_app/http/biosp_central.dart';
import 'package:fairticketsolutions_demo_app/http/biosp_event.dart';
import 'package:fairticketsolutions_demo_app/models/biosp_enums.dart';
import 'package:fairticketsolutions_demo_app/models/biosp_server_models.dart';
import 'package:fairticketsolutions_demo_app/models/biometrics_capture_result_model.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/face_capture_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provider/profile.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';

// Wrap this in a class for easy re-use throughout app
class BiospFaceCaptureActions {
  // Returns results of a face capture, or null if it fails
  static Future<BiometricsCaptureResult?> _performFaceCapture(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      // This is here because initState can't be async and why make everything more complicated when I can just do this
      final String faceCaptureProfile = await rootBundle.loadString('assets/profiles/face_capture_foxtrot_client.xml');

      return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FaceCaptureScreen(
              username: profileProvider.getUid(),
              profile: faceCaptureProfile,
            )
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Camera permission not granted!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return null;
    }
  }

  static Future<CheckLivenessResult?> _performLivenessCheck(BuildContext context, BiometricsCaptureResult faceCaptureResult) async {
    final CheckLivenessResult? checkLivenessResult = await BioSPCentral.checkFaceLiveness(faceCaptureResult.serverPackage);

    return checkLivenessResult;
  }

  // Perform face capture and return NULL unless face is LIVE
  static Future<Uint8List?> performFaceCaptureWithLiveness(BuildContext context) async {
    final BiometricsCaptureResult? faceCaptureResult = await _performFaceCapture(context);

    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    CheckLivenessResult? checkLivenessResult;

    if (faceCaptureResult != null) {
      checkLivenessResult = await _performLivenessCheck(context, faceCaptureResult);
    }

    if (checkLivenessResult != null && checkLivenessResult.score != null && checkLivenessResult.score! > 0) {
      return checkLivenessResult.capturedFrameBlob;
    }
    else {
      return null;
    }
  }

  // All in one function to perform face capture, enroll a subject if not already enrolled, and add biometrics
  static Future<void> enrollFromFace(BuildContext context, StorageService storageService) async {
    final Uint8List? capturedFrameBlob = await performFaceCaptureWithLiveness(context);

    if (capturedFrameBlob != null) {
      await profileProvider.setAvatarToFirebase(storageService, context, capturedFrameBlob); // Update app of new avatar
      await BioSPCentral.addSubjectDataFace(profileProvider.getUid(), null, null, null, [capturedFrameBlob]); // Add biometrics and subject if non existent
      EventSyncResult? sync = await BioSPEvent.sync(profileProvider.getUid());

      // Await until sync is completed, probably temporary
      if(sync != null && sync.jobId != null) {
        while (true) {
          await Future.delayed(const Duration(seconds: 1));

          EventSyncStatusResult? syncStatus = await BioSPEvent.syncStatus(sync.jobId!);

          if (syncStatus == null || !(syncStatus.isValid!)) break;
        }
      }
    }

    DialogBuilder.popDialog(context);
  }

  // Only works once user is enrolled and synced, if not use the function underneath
  static Future<double> verifyFace(BuildContext context) async {
    final Uint8List? capturedFrameBlob = await performFaceCaptureWithLiveness(context);

    VerifyBiometricsResult? verifyBiometricsResult;

    if (capturedFrameBlob != null) {
      verifyBiometricsResult = await BioSPEvent.verifySubjectInGallery(profileProvider.getUid(), capturedFrameBlob, null);
    }

    DialogBuilder.popDialog(context);

    return verifyBiometricsResult != null ? verifyBiometricsResult.matchScore! : 0;
  }

  // Gallery matching for given probe image, used when verifying doc
  static Future<double> verifyFaceInputEvent(BuildContext context, Uint8List probeImageBlob) async {
    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    VerifyBiometricsResult? verifyBiometricsResult = await BioSPEvent.verifySubjectInGallery(profileProvider.getUid(), probeImageBlob, null);

    DialogBuilder.popDialog(context);

    return verifyBiometricsResult != null ? verifyBiometricsResult.matchScore! : 0;
  }

  // Used before event server is introduced into the workflow
  static Future<double> verifyFaceInput(BuildContext context, Uint8List probeImageBlob, Uint8List knownImageBlob) async {
    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    VerifyBiometricsResult? verifyBiometricsResult = await BioSPCentral.verifyBiometrics(probeImageBlob, knownImageBlob, MatchType.face);

    DialogBuilder.popDialog(context);

    return verifyBiometricsResult != null ? verifyBiometricsResult.matchScore! : 0;
  }

  // AFAIK no way to clear a specific image from BioSP
  static Future<void> clearFace(BuildContext context, StorageService storageService) async {
    DialogBuilder.showLoadingDialog(context);

    // TODO: figure out how to clear from BioSP
    await profileProvider.setAvatarToFirebase(storageService, context, null);

    DialogBuilder.popDialog(context);
  }
}