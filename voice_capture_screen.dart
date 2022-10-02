import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/models/biometrics_capture_result_model.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VoiceCaptureScreen extends StatefulWidget {
  const VoiceCaptureScreen({
    Key? key,
    required this.username,
    required this.captureTimeout,
    required this.minRecordingLength,
    required this.captureOnDevice,
    required this.phrase,
    required this.title,
    this.isRegistration = false
  }) : super(key: key);

  final String username;
  final double captureTimeout;
  final double minRecordingLength;
  final bool captureOnDevice;
  final String phrase;
  final String title;
  final bool isRegistration;

  @override
  State<VoiceCaptureScreen> createState() => _VoiceCaptureScreenState();
}

class _VoiceCaptureScreenState extends State<VoiceCaptureScreen> with TickerProviderStateMixin {
  final MethodChannel _platform = const MethodChannel("com.example.fairticketsolutions_demo_app/voice_capture");

  late Animation<double> progressAnimation;
  late AnimationController progressAnimationController;

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

    // Create animation controllers
    progressAnimationController = AnimationController(
        duration: Duration(milliseconds: (widget.captureTimeout * 1000).toInt()),
        vsync: this
    );
    progressAnimation = Tween<double>(begin: 0, end: 1)
        .animate(progressAnimationController)..addListener(() { setState(() { }); });

    // Bind call handler
    _platform.setMethodCallHandler(_methodCallHandler);

    // Launch the async SDK initialize function after screen has initialized
    _initVoiceCapture(widget.username, widget.captureTimeout, widget.minRecordingLength, widget.captureOnDevice);
  }

  @override
  void dispose() {
    progressAnimationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    await _destroyVoice(); // Free up resources before screen is popped

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Screen width and height so you can have percentages of screen
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    
    return WillPopScope(
      child: isLoading ? const Center(child: CircularProgressIndicator()) :
      Scaffold(
        resizeToAvoidBottomInset: false, // This prevents overflow when keyboard is brought up
        appBar: AppBar(
          leading: const SvgBackButton(),
          actions: const [SvgMenuButton()],
          backgroundColor: const Color(kHeaderBackgroundColor),
          elevation: 0,
          toolbarHeight: (height * 0.15) - statusBarHeight,
          title: Text(
            widget.title,
            style: const TextStyle(
                fontFamily: "OpenSans",
                fontWeight: FontWeight.w800,
                color: Color(kHeaderTextColor)
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: width,
              height: height * 0.15,
              decoration: const BoxDecoration(
                  gradient: kLightGradient
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(width * 0.07, 0.0, 0.0, 0.0),
                child: Text(
                  widget.isRegistration ? "Voice Registration" : "Please repeat the following:",
                  style: const TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ),
            Container(
              color: const Color(kHeaderBackgroundColor),
              width: width,
              height: height * 0.55,
              child: Padding(
                padding: EdgeInsets.all(width * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (widget.isRegistration)
                      const Text(
                        "Please, say the following phrase:",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    Text(
                      widget.phrase,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 35.0),
                    ),
                    SizedBox(
                      width: width * 0.50,
                      height: width * 0.50,
                      child: VoiceCaptureButton(
                        onPressed: () async {
                          /*await _startCaptureSession();*/
                          progressAnimationController.forward();
                        },
                      ),
                    ),
                    LinearProgressIndicator(
                      value: progressAnimation.value,
                      color: const Color(kHeaderBackgroundColor),
                      backgroundColor: const Color(kHeaderTextColor),
                    )
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: width,
              height: height * 0.15,
              decoration: const BoxDecoration(
                  gradient: kDarkGradient
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(width * 0.07, 0.0, 0.0, 0.0),
                child: Text(
                  feedback,
                  style: const TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: _onWillPop
    );
  }
}

class VoiceCaptureButton extends StatelessWidget {
  const VoiceCaptureButton({Key? key, required this.onPressed}) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ButtonStyle(
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), // Disable press animation
      shape: MaterialStateProperty.all<CircleBorder>(
          const CircleBorder()
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const Color(kSelectedButton);
            } else {
              return const Color(kUnselectedButton);
            }
          }
      ),
      elevation: MaterialStateProperty.all<double>(0.0),
    );

    ElevatedButton elevatedButton = ElevatedButton(
      child: SvgPicture.asset(
        "assets/icons/microphone.svg",
        semanticsLabel: "Voice capture button",
        color: const Color(kHeaderTextColor),
      ),
      style: buttonStyle,
      onPressed: onPressed,
    );

    return elevatedButton;
  }
}
