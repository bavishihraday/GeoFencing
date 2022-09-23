import 'dart:typed_data';

import 'package:fairticketsolutions_demo_app/http/biosp_central.dart';
import 'package:fairticketsolutions_demo_app/http/biosp_event.dart';
import 'package:fairticketsolutions_demo_app/models/biometrics_capture_result_model.dart';
import 'package:fairticketsolutions_demo_app/models/biosp_server_models.dart';
import 'package:fairticketsolutions_demo_app/provider/profile.dart';
import 'package:fairticketsolutions_demo_app/screens/voice_capture_screen.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceCaptureActions {
  // Constants for voice capture
  static const double _captureTimeout = 8.0;
  static const double _minRecordingLength = 1.0;
  static const bool _captureOnDevice = true;
  static const List<String> _phrases = ["The Dog is Black", "The Water is Blue", "Go Team Go"];

  static Future<BiometricsCaptureResult?> _performVoiceCapture(BuildContext context, String phrase) async {
    if (await Permission.microphone.request().isGranted) {
      return await Navigator.push(context, MaterialPageRoute(builder: (context) => VoiceCaptureScreen(
        username: profileProvider.getUid(),
        captureTimeout: _captureTimeout,
        minRecordingLength: _minRecordingLength,
        captureOnDevice: _captureOnDevice,
        phrase: phrase,
      )));
    } else {
      Fluttertoast.showToast(
        msg: "Microphone permission not granted!",
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

  static Future<CheckLivenessResult?> _performLivenessCheck(BuildContext context, BiometricsCaptureResult voiceCaptureResult, String phrase) async {
    final CheckLivenessResult? checkLivenessResult = await BioSPCentral.checkVoiceLiveness(voiceCaptureResult.serverPackage, phrase);

    return checkLivenessResult;
  }

  static Future<Uint8List?> performVoiceCaptureWithLiveness(BuildContext context, String phrase) async {
    final BiometricsCaptureResult? voiceCaptureResult = await _performVoiceCapture(context, phrase);

    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of voice capture to end of action

    CheckLivenessResult? checkLivenessResult;

    if (voiceCaptureResult != null) {
      checkLivenessResult = await _performLivenessCheck(context, voiceCaptureResult, phrase);
    }

    if (checkLivenessResult != null && checkLivenessResult.score != null && checkLivenessResult.score! > 0) {
      return voiceCaptureResult?.capturedBytes;
    }
    else {
      return null;
    }
  }

  static Future<void> enrollFromVoice(BuildContext context) async {
    List<VoicePackage> results = [];

    for (String phrase in _phrases) {
      Uint8List? result = await performVoiceCaptureWithLiveness(GlobalVariable.navState.currentContext!, phrase);

      DialogBuilder.popDialog(GlobalVariable.navState.currentContext!);

      if (result != null) {
        results.add(VoicePackage(phrase: phrase, blob: result));
      } else {
        Fluttertoast.showToast(
          msg: "Subject not live!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        break;
      }
    }

    DialogBuilder.showLoadingDialog(context); // Dialog opens here so that it loads from end of voice capture to end of action

    if (results.isNotEmpty) {
      await BioSPCentral.addSubjectDataVoice(profileProvider.getUid(), null, null, null, results);
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

    DialogBuilder.popDialog(GlobalVariable.navState.currentContext!);
  }

  static Future<bool> verifyVoice(BuildContext context, double matchThreshold) async {
    // Creates the effect of picking a "random phrase" and then checking the rest if it fails
    List<String> shuffledPhrases = List.from(_phrases);
    shuffledPhrases.shuffle();

    for (String phrase in shuffledPhrases) {
      Uint8List? capturedVoiceBlob = await performVoiceCaptureWithLiveness(context, phrase);

      VerifyBiometricsResult? verifyBiometricsResult;

      if (capturedVoiceBlob != null) {
        verifyBiometricsResult = await BioSPEvent.verifySubjectInGallery(
          profileProvider.getUid(),
          capturedVoiceBlob,
          phrase
        );

        if ((verifyBiometricsResult?.matchScore ?? 0) > matchThreshold) {
          DialogBuilder.popDialog(context);

          return true;
        }
      }
    }

    DialogBuilder.popDialog(context);
    return false;
  }
}