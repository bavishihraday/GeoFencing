import 'dart:convert';

import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_document_reader_api/document_reader.dart';
import 'package:getwidget/components/button/gf_button.dart';

class DocumentCaptureScreen extends StatefulWidget {
  const DocumentCaptureScreen({Key? key}) : super(key: key);

  @override
  State<DocumentCaptureScreen> createState() => _DocumentCaptureScreenState();
}

// Could be moved over to another class, but the async nature of Navigator.Push() is leveraged here to get rid of callbacks
class _DocumentCaptureScreenState extends State<DocumentCaptureScreen> {

  Future<void> _performDocCapture() async {
    ByteData licenseData = await rootBundle.load("assets/regula.license");

    // Initialize reader with license and catch errors
    try {
      // If database is not present on machine, or existing database is incompatible with current
      // Regula SDK version, download a new one. Does not update based on latest version of database.
      await DocumentReader.prepareDatabase("Full");

      String license = base64.encode(licenseData.buffer.asUint8List(licenseData.offsetInBytes, licenseData.lengthInBytes));

      dynamic result = await DocumentReader.initializeReader({ "license": license });

      debugPrint(result);
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }

    // Set the available features via setting scenario
    await DocumentReader.setConfig({
      "processParams": {
        "scenario": ScenarioIdentifier.SCENARIO_FULL_PROCESS,
        "timeout": 9999, // High timeouts for testing, might want to lower them later
        "timeoutFromFirstDetect": 9999,
        "timeoutFromFirstDocType": 9999,
        "logs": true
      },
      "functionality": {
        "showCloseButton": false,
        "showCaptureButton": true,
        "showCaptureButtonDelayFromDetect": 0
      }
    });

    // Handle events from document reader API
    const EventChannel('flutter_document_reader_api/event/completion')
        .receiveBroadcastStream()
        .listen((jsonString) => _handleCompletion(DocumentReaderCompletion.fromJson(json.decode(jsonString))));

    // Show scanner once initialization is complete, pushed over spinner
    DocumentReader.showScanner();
  }

  void _handleCompletion(DocumentReaderCompletion? completion) {
    if (completion != null) {
      switch (completion.action) {
        case DocReaderAction.COMPLETE: _handleCompleteAction(completion.results); break;
        case DocReaderAction.CANCEL: _handleCancelAction(); break;
        case DocReaderAction.ERROR: _handleErrorAction(); break;
        case DocReaderAction.MORE_PAGES_AVAILABLE: debugPrint("DOCUMENT_MORE_PAGES"); break;
        case DocReaderAction.NOTIFICATION: debugPrint("DOCUMENT_NOTIFICATION"); break;
        case DocReaderAction.PROCESS: debugPrint("DOCUMENT_PROCESS"); break;
        case DocReaderAction.PROCESS_IR_FRAME: debugPrint("DOCUMENT_PROCESS_IR"); break;
        case DocReaderAction.PROCESS_WHITE_FLASHLIGHT: debugPrint("DOCUMENT_PROCESS_WHITE"); break;
        case DocReaderAction.PROCESS_WHITE_UV_IMAGES: debugPrint("DOCUMENT_PROCESS_WHITE_UV"); break;
        case DocReaderAction.TIMEOUT: _handleTimeoutAction(); break;
      }
    }
    else {
      debugPrint("DOCUMENT_NULL_COMPLETION");
    }
  }

  // Handle capture-ending actions from document capture

  Future<void> _handleCompleteAction(DocumentReaderResults? results) async {
    debugPrint("DOCUMENT_COMPLETION");

    // Pop spinner after document reader is de-initialized, and return results
    await Navigator.maybePop(context, results);
  }

  Future<void> _handleCancelAction() async {
    debugPrint("DOCUMENT_CANCEL");

    // Pop spinner after document reader is de-initialized
    await Navigator.maybePop(context);
  }

  Future<void> _handleErrorAction() async {
    debugPrint("DOCUMENT_ERROR");

    // Pop spinner after document reader is de-initialized and inform user
    await Navigator.maybePop(context);
    DialogBuilder.showInfoDialog(context, "Document Capture", "And error has occurred with document capture");
  }

  Future<void> _handleTimeoutAction() async {
    debugPrint("DOCUMENT_TIMEOUT");

    // Pop spinner after document reader is de-initialized and inform user
    await Navigator.maybePop(context);
    DialogBuilder.showInfoDialog(context, "Document Capture", "Timeout");
  }

  @override
  void initState() {
    super.initState();

    _performDocCapture();
  }

  Future<bool> _onWillPop() async {
    DocumentReader.deinitializeReader();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: const Center(child: CircularProgressIndicator()),
        onWillPop: _onWillPop
    );
  }
}
