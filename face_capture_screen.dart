import 'package:fairticketsolutions_demo_app/constants/colors.dart';
import 'package:fairticketsolutions_demo_app/models/biometrics_capture_result_model.dart';
import 'package:fairticketsolutions_demo_app/widgets/common_ui_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../face_capture.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen(
      {Key? key, required this.username, required this.profile, required this.title})
      : super(key: key);
  final String username;
  final String profile;
  final String title;

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  final FaceCapture _faceCaptureLibrary = FaceCapture();

  late CaptureSessionStatus _status;
  late AutoCaptureFeedback _feedback;
  late Uint8List _imageBlob;
  late Future<void> _faceCaptureListener;
  late Workflow _faceCaptureWorkflow;
  late List _cameras;

  bool _doListen = false;

  // This is run on creation of the widget, not after every setState
  @override
  void initState() {
    super.initState();

    // These can be changed in settings later
    _cameras = _faceCaptureLibrary.getCameraList(CameraPosition.FRONT);
    _faceCaptureWorkflow = _faceCaptureLibrary.workflowCreate(AW_FACE_CAPTURE_FOXTROT);

    // Set various properties
    _faceCaptureWorkflow.setPropertyString(WorkflowProperty.PROFILE, widget.profile);
    _faceCaptureWorkflow.setPropertyString(WorkflowProperty.USERNAME, widget.username);
    _faceCaptureWorkflow.setPropertyDouble(WorkflowProperty.TIMEOUT, 0.0);
    _cameras[0].setOrientation(CameraOrientation.PORTRAIT);

    // Start capture session
    _faceCaptureLibrary.startCaptureSession(_faceCaptureWorkflow, _cameras[0]);

    // Start async listener
    _doListen = true;
    _faceCaptureListener = _faceCaptureListen();
  }

  // Since there is no actual listener for the FaceCapture class, this is how you would check for updates
  // (the demo application does this just obfuscated behind overcomplicated code)
  Future<void> _faceCaptureListen() async {
    // _doListen is here to make 100% sure the while loop stops when the widget is popped
    while (_doListen) {
      CaptureSessionState state = _faceCaptureLibrary.getCaptureSessionState();

      _handleCaptureState(state);
      state.dispose();

      // Wait a bit as to not overload device and to maintain a frame-rate (~30fps)
      await Future.delayed(const Duration(milliseconds: 33));
    }
  }

  // Translate enumerable to strings
  String _getFeedbackString(AutoCaptureFeedback? feedback) {
    switch (feedback) {
      case AutoCaptureFeedback.FACE_COMPLIANT:
        return "Compliant";
      case AutoCaptureFeedback.NO_FACE_DETECTED:
        return "No Face Detected";
      case AutoCaptureFeedback.MULTIPLE_FACES_DETECTED:
        return "Multiple Faces Detected";
      case AutoCaptureFeedback.INVALID_POSE:
        return "Invalid Pose";
      case AutoCaptureFeedback.FACE_TOO_FAR:
        return "Face Too Far";
      case AutoCaptureFeedback.FACE_TOO_CLOSE:
        return "Face Too Close";
      case AutoCaptureFeedback.FACE_ON_LEFT:
        return "Face on Left";
      case AutoCaptureFeedback.FACE_ON_RIGHT:
        return "Face on Right";
      case AutoCaptureFeedback.FACE_TOO_HIGH:
        return "Face Too High";
      case AutoCaptureFeedback.FACE_TOO_LOW:
        return "Face Too Low";
      case AutoCaptureFeedback.INSUFFICIENT_LIGHTING:
        return "Insufficient Lighting";
      case AutoCaptureFeedback.LEFT_EYE_CLOSED:
        return "Left Eye Closed";
      case AutoCaptureFeedback.RIGHT_EYE_CLOSED:
        return "Right Eye Closed";
      case AutoCaptureFeedback.DARK_GLASSES_DETECTED:
        return "Dark Glasses Detected";
      default:
        return "No feedback";
    }
  }

  // Handle state and react accordingly to library's status
  void _handleCaptureState(CaptureSessionState state) {
    setState(() {
      _status = state.getCaptureSessionStatus();

      switch (_status) {
        case CaptureSessionStatus.IDLE:
          debugPrint('CAPTURE SESSION FEEDBACK: Idling...');
          break;
        case CaptureSessionStatus.STARTING:
          debugPrint('CAPTURE SESSION FEEDBACK: Starting...');
          break;
        case CaptureSessionStatus.CAPTURING:
          // Update properties related to user end display
          _feedback = state.getCaptureSessionFeedback();
          _imageBlob = state.getCaptureSessionFrame();

          debugPrint('CAPTURE SESSION FEEDBACK: $_feedback');
          break;
        case CaptureSessionStatus.POST_CAPTURE_PROCESSING:
          debugPrint('CAPTURE SESSION FEEDBACK: Post capture processing...');
          break;
        case CaptureSessionStatus.COMPLETED:
          Navigator.maybePop(context, BiometricsCaptureResult(_imageBlob, _faceCaptureLibrary.getServerPackage(_faceCaptureWorkflow, PackageType.HIGH_USABILITY))); // Send captured image and JSON for liveness check back
          break;
        case CaptureSessionStatus.ABORTED:
          Fluttertoast.showToast(
            msg: "Capture aborted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.maybePop(context);
          break;
        case CaptureSessionStatus.STOPPED:
          Fluttertoast.showToast(
            msg: "Capture stopped!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.maybePop(context);
          break;
        case CaptureSessionStatus.TIMED_OUT:
          Fluttertoast.showToast(
            msg: "Capture aborted due to timeout!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.maybePop(context);
          break;
        default:
          debugPrint('CAPTURE SESSION FEEDBACK: CaptureSessionStatus was null');
      }
    });
  }

  Future<bool> _onWillPop() async {
    _doListen = false;

    // Wait for _faceCaptureListen's while loop to finish before popping
    await _faceCaptureListener.whenComplete(() => {
      if (_faceCaptureLibrary.libId >= 0) {
        _faceCaptureWorkflow.dispose(),
        _faceCaptureLibrary.stopCaptureSession(),
        _faceCaptureLibrary.dispose()
      },
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    // Screen width and height so you can have percentages of screen
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;

    return WillPopScope(
      child: Scaffold(
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
                child: const Text(
                  'Capture Face ID',
                  style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              width: width,
              height: height * 0.55,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (_imageBlob.isNotEmpty)
                    Image.memory(
                      _imageBlob,
                      gaplessPlayback: true,
                      height: height * 0.55,
                      width: width,
                      fit: BoxFit.cover,
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.10),
                    child: SvgPicture.asset(
                      "assets/icons/face_reticule.svg",
                      semanticsLabel: "Face Capture Area",
                      color: _feedback == AutoCaptureFeedback.FACE_COMPLIANT ? Colors.green : const Color(kHeaderTextColor)
                    ),
                  )
                ],
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
                  _getFeedbackString(_feedback),
                  style: const TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black54,
      ),
      onWillPop: _onWillPop,
    );
  }
}