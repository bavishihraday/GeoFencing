import 'dart:typed_data';

import 'package:fairticketsolutions_demo_app/capture_actions/aws_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/doc_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/biosp_voice_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/models/biosp_enums.dart';
import 'package:fairticketsolutions_demo_app/screens/enroll_choice_screen.dart';
import 'package:fairticketsolutions_demo_app/services/auth_service.dart';
import 'package:fairticketsolutions_demo_app/services/storage_service.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:fairticketsolutions_demo_app/utils/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../utils/doc_utils.dart';

class WorkflowActions {
  // Executes the workflow described for when a new user is registered,
  // returns true if it is completed properly or false if otherwise
  static Future<bool> registerWorkflow(
        StorageService storageService,
        String fullName,
        AuthService authService,
        String email,
        String password
      ) async {
    // First, snap selfie without enrolling subject:
    Uint8List? selfie = (await AwsFaceCaptureActions.performFaceCapture(GlobalVariable.navState.currentContext!))?.capturedBytes;
    DialogBuilder.popDialog(GlobalVariable.navState.currentContext!); // Pop loading dialog after liveness is received

    if (selfie == null) {
      Fluttertoast.showToast(
        msg: "No capture or subject not live!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return false;
    }

    // Get driving license for comparison
    DocumentReaderResults? drivingLicense = await DocCaptureActions.performDocCapture(GlobalVariable.navState.currentContext!);
    // Returns false if null, therefore no need for null checking
    if (!(DocUtils.checkIfDrivingLicense(drivingLicense?.documentType[0]?.dType))) {
      Fluttertoast.showToast(
        msg: "No captured DL!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return false;
    }

    // Convert to jpg for BioSP
    // TODO: This might need to go back?
    // Uint8List docPortraitPng = Uri.parse("data:image/png;base64," + drivingLicense!.getGraphicFieldImageByType(eGraphicFieldType.GF_DOCUMENT_IMAGE)!.replaceAll('\n', '')).data!.contentAsBytes();
    // Uint8List docPortrait = Uint8List.fromList(encodeJpg(decodePng(docPortraitPng)!));
    Uint8List portraitDL = Uri.parse(
        "data:image/jpg;base64," + drivingLicense!.getGraphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT)!.replaceAll('\n', '')
    ).data!.contentAsBytes();

    String fullNameDL = (drivingLicense.getTextFieldValueByType(EVisualFieldType.FT_GIVEN_NAMES) ?? "") + " " + (drivingLicense.getTextFieldValueByType(EVisualFieldType.FT_SURNAME) ?? "");
    if (fullNameDL.toUpperCase() != fullName.toUpperCase()) return false;

    double doesFaceMatch = await BiospFaceCaptureActions.verifyFaceInput(GlobalVariable.navState.currentContext!, selfie, portraitDL);
    if (doesFaceMatch == 0) return false;

    await authService.createUserWithEmailAndPassword(email, password);

    MatchType enrollChoice = await Navigator.push(
        GlobalVariable.navState.currentContext!,
        MaterialPageRoute(builder: (context) => const EnrollChoiceScreen())
    );

    if (enrollChoice == MatchType.voice) {
      await VoiceCaptureActions.enrollFromVoice(GlobalVariable.navState.currentContext!);

      return true;
    } else if (enrollChoice == MatchType.face) {
      await BiospFaceCaptureActions.enrollFromFace(GlobalVariable.navState.currentContext!, storageService);

      return true;
    }

    // If something fails, make sure to return false
    return false;
  }
}
