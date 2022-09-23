import 'dart:typed_data';
import 'package:fairticketsolutions_demo_app/models/biometrics_capture_result_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../face_capture.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FaceCaptureScreen extends StatefulWidget {
  const FaceCaptureScreen(
      {Key? key, required this.username, required this.profile})
      : super(key: key);
  final String username;
  final String profile;

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
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getFeedbackString(_feedback)),
          centerTitle: true,
        ),
        body: Center(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (_imageBlob.isNotEmpty)
                Image.memory(
                  _imageBlob,
                  gaplessPlayback: true,
                  height: MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight), // Get height available to image
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fitHeight,
                ),
              CustomPaint(
                painter: FaceAreaIndicator(
                  _feedback == AutoCaptureFeedback.FACE_COMPLIANT ? Colors.green : Colors.red,
                  MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight),
                  MediaQuery.of(context).size.width
                ),
                child: Container(),
              )
            ],
          ),
        ),
        backgroundColor: Colors.black54,
      ),
      onWillPop: _onWillPop,
    );
  }
}

// Draws oval that indicates where you put your face, and also draws a shadow outside of it for good measure
class FaceAreaIndicator extends CustomPainter {
  FaceAreaIndicator(this.color, this.height, this.width);
  final Color color;
  final double height;
  final double width;

  @override
  Future<void> paint(Canvas canvas, Size size) async {
    final Paint paint = Paint();
    final Paint ovalPaint = Paint();
    final Rect rect = Rect.fromPoints(const Offset(0, 0), Offset(width, height)); // Create rectangle from available size
    final Rect ovalRect = Rect.fromPoints(Offset((width / 2) - (width / 3), (height / 5)), Offset((width / 2) + (width / 3), (height / 2) + (height / 5))); // This is a mess but it looks pretty, is accurate, and scales, so...

    // Set properties for Area Indicator shadow
    paint.color = Colors.white30.withOpacity(0.50);

    // Set properties for Area Indicator oval
    ovalPaint.color = color;
    ovalPaint.style = PaintingStyle.stroke;
    ovalPaint.strokeWidth = 10;

    // Draw Shadow with oval cut out and then draw oval
    canvas.drawPath(Path.combine(PathOperation.difference, Path()..addRect(rect), Path()..addOval(ovalRect)), paint);
    canvas.drawOval(ovalRect, ovalPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}