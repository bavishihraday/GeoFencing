import 'dart:typed_data';
import 'package:fairticketsolutions_demo_app/constants/aws_face_constants.dart';
import 'package:fairticketsolutions_demo_app/http/aws_face.dart';
import 'package:fairticketsolutions_demo_app/http/biosp_central.dart';
import 'package:fairticketsolutions_demo_app/models/aws_face_models.dart';
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
class AwsFaceCaptureActions {
  // Returns results of a face capture, or null if it fails
  static Future<BiometricsCaptureResult?> performFaceCapture(BuildContext context) async {
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
  static Future<Uint8List?> _performFaceCaptureWithLiveness(BuildContext context) async {
    final BiometricsCaptureResult? faceCaptureResult = await performFaceCapture(context);

    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    CheckLivenessResult? checkLivenessResult;

    if (faceCaptureResult != null) {
      checkLivenessResult = await _performLivenessCheck(context, faceCaptureResult);
    }

    // TODO: turn liveness back on (>= 0 -> > 0)
    if (checkLivenessResult != null && checkLivenessResult.score != null && checkLivenessResult.score! >= 0) {
      return checkLivenessResult.capturedFrameBlob;
    }
    else {
      return null;
    }
  }

  // All in one function to perform face capture, enroll a subject if not already enrolled, and add biometrics
  static Future<void> enrollFromFace(BuildContext context, StorageService storageService) async {
    final BiometricsCaptureResult? faceCaptureResult = await performFaceCapture(context);

    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    if (faceCaptureResult != null) {
      try {
        await profileProvider.setAvatarToFirebase(storageService, context, faceCaptureResult.capturedBytes); // Update app of new avatar
        await AwsFace.registerFace("${profileProvider.getUid()}.jpeg", faceCaptureResult.capturedBytes); // Add biometrics and subject if non existent
        await AwsFace.moveToCollection("${profileProvider.getUid()}.jpeg", kDummyCollection); // Move image to collection for 1-N

        DialogBuilder.popDialog(context);
      } on Exception catch (e) {
        DialogBuilder.popDialog(context);
        DialogBuilder.showInfoDialog(context, "Server Error", "$e"); // This can be replaced with more sophisticated error handling later
      }
    }
  }

  // True if face is verified to match probe image
  static Future<bool> verifyFace(BuildContext context) async {
    final BiometricsCaptureResult? faceCaptureResult = await performFaceCapture(context);

    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    if (faceCaptureResult != null) {
      try {
        FaceActionResult faceActionResult = await AwsFace.matchFace("${profileProvider.getUid()}.jpeg", faceCaptureResult.capturedBytes, kMatchFaceThreshold);

        DialogBuilder.popDialog(context);

        return faceActionResult.matchedFaces.isNotEmpty;
      } on Exception catch (e) {
        DialogBuilder.popDialog(context);
        DialogBuilder.showInfoDialog(context, "Server Error", "$e"); // This can be replaced with more sophisticated error handling later
      }
    }
    else {
      DialogBuilder.popDialog(context);
    }

    return false; // Return false if various if/else check fail
  }

  // True if face is verified to match probe image
  static Future<bool> verifyFaceInput(BuildContext context, Uint8List probeImage) async {
    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    try {
      FaceActionResult faceActionResult = await AwsFace.matchFace("${profileProvider.getUid()}.jpeg", probeImage, kMatchFaceThreshold);

      DialogBuilder.popDialog(context);

      return faceActionResult.matchedFaces.isNotEmpty;
    } on Exception catch (e) {
      DialogBuilder.popDialog(context);
      DialogBuilder.showInfoDialog(context, "Server Error", "$e"); // This can be replaced with more sophisticated error handling later
    }

    return false; // Return false if various if/else check fail
  }

  static Future<String> findFace(BuildContext context) async {
    final BiometricsCaptureResult? faceCaptureResult = await performFaceCapture(context);

    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of face capture to end of action

    if (faceCaptureResult != null) {
      try {
        FaceActionResult faceActionResult = await AwsFace.findFace(kDummyCollection, faceCaptureResult.capturedBytes, kFindFaceThreshold);

        DialogBuilder.popDialog(context);

        if (faceActionResult.matchedFaces.isNotEmpty) {
          String filename = faceActionResult.matchedFaces[0].fileName!; // List is sorted so this is the highest similarity match

          return filename.substring(0, filename.length - 5); // removes the .jpeg from the image to get the UID of the person
        }
      } on Exception catch (e) {
        DialogBuilder.popDialog(context);
        DialogBuilder.showInfoDialog(context, "Server Error", "$e"); // This can be replaced with more sophisticated error handling later
      }
    }
    else {
      DialogBuilder.popDialog(context);
    }

    return ""; // Return 0 if various if/else check fail
  }

  static Future<void> clearFace(BuildContext context, StorageService storageService) async {
    try {
      DialogBuilder.showLoadingDialog(context);

      await profileProvider.setAvatarToFirebase(storageService, context, null);
      await AwsFace.deleteImage("${profileProvider.getUid()}.jpeg");

      DialogBuilder.popDialog(context);
    } on Exception catch (e) {
      DialogBuilder.popDialog(context);
      DialogBuilder.showInfoDialog(context, "Server Error", "$e"); // This can be replaced with more sophisticated error handling later
    }
  }
}