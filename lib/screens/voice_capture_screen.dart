import 'dart:typed_data';

import 'package:fairticketsolutions_demo_app/models/biometrics_capture_result_model.dart';
import 'package:fairticketsolutions_demo_app/widgets/voice_capture_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoiceCaptureScreen extends StatefulWidget {
  const VoiceCaptureScreen({
    Key? key,
    required this.username,
    required this.captureTimeout,
    required this.minRecordingLength,
    required this.captureOnDevice,
    required this.phrase
  }) : super(key: key);

  final String username;
  final double captureTimeout;
  final double minRecordingLength;
  final bool captureOnDevice;
  final String phrase;

  @override
  State<VoiceCaptureScreen> createState() => _VoiceCaptureScreenState();
}

class _VoiceCaptureScreenState extends State<VoiceCaptureScreen> {
  final MethodChannel _platform = const MethodChannel("com.example.fairticketsolutions_demo_app/voice_capture");
  
  bool shouldBeginProgress = false;
  bool isLoading = true;
  String feedback = "No Feedback";

  // Functions to communicate with kotlin

  Future<void> _initVoiceCapture(String username, double captureTimeout, double minRecordingLength, bool captureOnDevice) async {
    try {
      await _platform.invokeMethod("initVoiceCapture", {
        "username": username,
        "captureTimeout": captureTimeout,
        "minRecordingLength": minRecordingLength,
        "captureOnDevice": captureOnDevice
      });

      // Removes spinner and allows user to interact with voice recording once library is initialized
      setState(() {
        isLoading = false;
      });
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> _startCaptureSession() async {
    try {
      await _platform.invokeMethod("startVoiceCapture");
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<String> _getServerPackage() async {
    try {
      String result = await _platform.invokeMethod("getServerPackage");

      return result;
    } on PlatformException catch (e) {
      debugPrint(e.message);

      return "";
    }
  }

  Future<Uint8List?> _getRecording() async {
    try {
      Uint8List result = await _platform.invokeMethod("getRecording");

      return result;
    } on PlatformException catch (e) {
      debugPrint(e.message);

      return null;
    }
  }

  Future<void> _destroyVoice() async {
    try {
      await _platform.invokeMethod("destroyVoice");
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  // Call handler to handle results from captureSessionStatusCallback() in kotlin
  Future<dynamic> _methodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "captureSessionStatusCallback": _handleCaptureSessionStatus(methodCall.arguments as String); break;
      default: throw MissingPluginException('notImplemented');
    }
  }

  void _handleCaptureSessionStatus(String status) {
    switch (status) {
      case "VOICE_PREPARING": _handlePreparingStatus(); break;
      case "VOICE_STARTING": _handleStartingStatus(); break;
      case "VOICE_CAPTURING": _handleCapturingStatus(); break;
      case "VOICE_PROCESSING": _handleProcessingStatus(); break;
      case "VOICE_COMPLETED": _handleCompletedStatus(); break;
      case "VOICE_ABORTED": _handleAbortedStatus(); break;
      default: debugPrint(status); break;
    }
  }

  // Handlers for different states

  void _handlePreparingStatus() {
    setState(() {
      feedback = "Preparing";
    });
  }

  void _handleStartingStatus() {
    setState(() {
      feedback = "Starting";
    });
  }

  void _handleCapturingStatus() {
    setState(() {
      feedback = "Capturing";
      shouldBeginProgress = true;
    });
  }

  void _handleProcessingStatus() {
    setState(() {
      isLoading = true;
    });
  }

  Future<void> _handleCompletedStatus() async {
    Navigator.maybePop(context, BiometricsCaptureResult((await _getRecording())!, await _getServerPackage()));
  }

  void _handleAbortedStatus() async {
    setState(() {
      isLoading = true;
    });

    Navigator.maybePop(context); // Error will be handled when null is received
  }

  @override
  void initState() {
    super.initState();

    // Bind call handler
    _platform.setMethodCallHandler(_methodCallHandler);

    // Launch the async SDK initialize function after screen has initialized
    _initVoiceCapture(widget.username, widget.captureTimeout, widget.minRecordingLength, widget.captureOnDevice);
  }

  Future<bool> _onWillPop() async {
    await _destroyVoice(); // Free up resources before screen is popped

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: isLoading ? const Center(child: CircularProgressIndicator()) :
        Scaffold(
          appBar: AppBar(
            title: Text(feedback),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Please press below and say:\n${widget.phrase}",
                  style: Theme.of(context).textTheme.headline3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 60,
                ),
                VoiceCaptureButton(
                  duration: (widget.captureTimeout * 1000).toInt(),
                  shouldBeginProgress: shouldBeginProgress,
                  onPressed: () async { await _startCaptureSession(); },
                ),
              ],
            ),
          ),
        ),
        onWillPop: _onWillPop
    );
  }
}
