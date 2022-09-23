import 'dart:convert';

import 'package:fairticketsolutions_demo_app/capture_actions/aws_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/screens/document_capture_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

class DocCaptureActions {
  static Future<DocumentReaderResults?> performDocCapture(BuildContext context) async {
    if (await Permission.camera.request().isGranted) {
      return await Navigator.push(context, MaterialPageRoute(builder: (context) => const DocumentCaptureScreen()));
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

  static Future<double> verifyDoc(BuildContext context) async {
    DocumentReaderResults? results = await performDocCapture(context);

    if (results != null) {
      return await BiospFaceCaptureActions.verifyFaceInputEvent(context, base64Decode(results.getGraphicFieldImageByType(EGraphicFieldType.GF_PORTRAIT)!.replaceAll("\n", "")));
    }

    return 0;
  }
}