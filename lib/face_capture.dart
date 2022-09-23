import 'dart:io' show Platform;

import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';



//******************** Public *********************//

class CaptureSessionRoi {
  late int roiX;
  late int roiY;
  late int roiWidth;
  late int roiHeight;
}

class FaceCapture {
  late int libId;

  FaceCapture() {
    libId = __aware_interop_private_faceCaptureCreate();
  }

  Workflow workflowCreate(String workflowName) {
    return __aware_interop_private_faceCaptureWorkflowCreate(libId, workflowName.toNativeUtf8());
  }

  CaptureSessionState getCaptureSessionState() {
    return __aware_interop_private_faceCaptureGetCaptureSessionState(libId);
  }

  List getCameraList(CameraPosition cameraPosition) {
    return __aware_interop_private_faceCaptureGetCameraList(libId, cameraPosition.index);
  }

  void startCaptureSession(Workflow workflow, Camera camera) {
    return __aware_interop_private_faceCaptureStartCaptureSession(libId, workflow.workflowId, camera.cameraId);
  }

  void stopCaptureSession() {
    return __aware_interop_private_faceCaptureStopCaptureSession(libId);
  }

  CaptureSessionRoi getCaptureSessionRoi() {
    CaptureSessionRoi capRoi = CaptureSessionRoi();
    capRoi.roiX = 0;
    capRoi.roiY = 0;
    capRoi.roiWidth = 0;
    capRoi.roiHeight = 0;

    __aware_interop_private_getFaceCaptureSessionRoi(libId, capRoi);
    return capRoi;
  }

  String getServerPackage(Workflow workflow, PackageType packageType) {
    return __aware_interop_private_getFaceCaptureServerPackage(libId, workflow.workflowId, packageType.index);
  }

  int getVersion() {
    return __aware_interop_private_getFaceCaptureVersionInt();
  }

  String getVersionString() {
    return __aware_interop_private_getFaceCaptureVersionString();
  }

  void dispose() {
    return __aware_interop_private_faceCaptureDispose(libId);
  }
}

class CaptureSessionState {
  int libId;
  int stateId;

  CaptureSessionState(this.libId, this.stateId);

  CaptureSessionStatus getCaptureSessionStatus() {
    return __aware_interop_private_getFaceCaptureSessionStatus(libId, stateId);
  }

  AutoCaptureFeedback getCaptureSessionFeedback() {
    return __aware_interop_private_getFaceCaptureSessionFeedback(libId, stateId);
  }

  Uint8List getCaptureSessionFrame() {
    return __aware_interop_private_getFaceCaptureSessionFrame(libId, stateId);
  }

  void dispose() {
    return __aware_interop_private_faceCaptureSessionStateDispose(libId, stateId);
  }
}

class Workflow {
  int libId;
  int workflowId;

  Workflow(this.libId, this.workflowId);

  //We tried passing in string, but it did not work.
  void setPropertyString(WorkflowProperty workflowProperty, String value) {
    __aware_interop_private_faceCaptureWorkflowSetPropertyString(libId, workflowId, workflowProperty.index, value.toNativeUtf8());
  }
  void setPropertyDouble(WorkflowProperty workflowProperty, double value) {
    __aware_interop_private_faceCaptureWorkflowSetPropertyDouble(libId, workflowId, workflowProperty.index, value);
  }
  void dispose() {
    __aware_interop_private_faceCaptureWorkflowDispose(libId, workflowId);
  }
}

class Camera {
  int libId;
  int cameraId;

  Camera(this.libId, this.cameraId);

  String getName() {
    return __aware_interop_private_faceCaptureGetCameraName(libId, cameraId);
  }

  void setOrientation(CameraOrientation cameraOrientation) {
    __aware_interop_private_faceCaptureSetCameraOrientation(libId, cameraId, cameraOrientation.index);
  }

  void dispose() {
    __aware_interop_private_faceCaptureCameraDispose(libId, cameraId);
  }
}

/* Error Codes */
class FaceCaptureException implements Exception {
  int errorCode = 0;
  String message = "";

  FaceCaptureException(int error, String msg) {
    errorCode = error;
    message = msg;
  }
}

/* No errors or warnings. */
const AW_FACE_CAPTURE_E_NO_ERRORS = 0;

/* An internal error occurred. */
const AW_FACE_CAPTURE_E_INTERNAL_ERROR = 1;

/* The Face Capture object was NULL. */
const AW_FACE_CAPTURE_E_NULL_FACE_CAPTURE_OBJ = 2;

/* The trial expiration has passed. */
const AW_FACE_CAPTURE_E_TRIAL_EXPIRATION_PASSED = 3;

/* The library failed to allocate memory. */
const AW_FACE_CAPTURE_E_OUT_OF_MEMORY = 100;

/* Could not initialize the Face Capture library or a required component. */
const AW_FACE_CAPTURE_E_INITIALIZATION_FAILED = 101;

/* Invalid workflow object. */
const AW_FACE_CAPTURE_E_INVALID_WORKFLOW = 200;

/* No workflow exists with the given name. */
const AW_FACE_CAPTURE_E_UNKNOWN_WORKFLOW = 201;

/* Workflows cannot be modified while a capture session is in progress. */
const AW_FACE_CAPTURE_E_WORKFLOW_IN_USE = 202;

/* Invalid package type. */
const AW_FACE_CAPTURE_E_INVALID_PACKAGE_TYPE = 203;

/* Invalid workflow property. */
const AW_FACE_CAPTURE_E_INVALID_WORKFLOW_PROPERTY = 250;

/* The specified value is the wrong type for the specified property. */
const AW_FACE_CAPTURE_E_WORKFLOW_PROPERTY_TYPE_MISMATCH = 251;

/* The specified value is not valid for the specified property. */
const AW_FACE_CAPTURE_E_INVALID_PROPERTY_VALUE = 252;

/* Invalid camera object. */
const AW_FACE_CAPTURE_E_INVALID_CAMERA = 300;

/* No camera exists with the given name. */
const AW_FACE_CAPTURE_E_UNKNOWN_CAMERA = 301;

/* Cameras cannot be modified while a capture session is in progress. */
const AW_FACE_CAPTURE_E_CAMERA_IN_USE = 302;

/* Camera could not be initialized. */
const AW_FACE_CAPTURE_E_CAMERA_INITIALIZATION = 303;

/* No initializable cameras detected. */
const AW_FACE_CAPTURE_E_NO_INITIALIZABLE_CAMERAS = 304;

/* The camera position specified was an invalid value. */
const AW_FACE_CAPTURE_E_INVALID_CAMERA_POSITION = 305;

/* The camera orientation specified was an invalid value. */
const AW_FACE_CAPTURE_E_INVALID_CAMERA_ORIENTATION = 306;

/* A capture session is already in progress. */
const AW_FACE_CAPTURE_E_CAPTURE_IN_PROGRESS = 400;

/* The last capture session for the specified Workflow was aborted. */
const AW_FACE_CAPTURE_E_CAPTURE_SESSION_UNAVAILABLE = 401;

/* The callback function specified is invalid. */
const AW_FACE_CAPTURE_E_INVALID_CALLBACK_FUNCTION = 402;

/* No Face Analysis service was specified by the Workflow. */
const AW_FACE_CAPTURE_E_NO_FACE_ANALYSIS_SERVICE_SPECIFIED = 403;

/* The Face Analysis service specified by the Workflow cannot be reached. */
const AW_FACE_CAPTURE_E_FACE_ANALYSIS_SERVICE_UNREACHABLE = 404;

/* No capture profile was specified by the Workflow. */
const AW_FACE_CAPTURE_E_NO_CAPTURE_PROFILE = 405;

/* The capture profile set in the Workflow was invalid. */
const AW_FACE_CAPTURE_E_INVALID_CAPTURE_PROFILE = 406;

/* Foxtrot Workflow. */
const AW_FACE_CAPTURE_FOXTROT = "Foxtrot";



/* Adjustable properties for Workflow objects. */
enum WorkflowProperty
{
  /* A string value used to set the Username/ID fields when communicating
       with Knomi S Services. */
  USERNAME,

  /* A double value indicating the maximum duration in seconds for
       attempting face capture before ending the capture session. */
  TIMEOUT,

  /* A string value used to set the capture criteria for Face Capture. */
  PROFILE
}

/* Device camera orientations. */
enum CameraOrientation
{
  /* Portrait orientation - camera is held vertically. */
  PORTRAIT,

  /* Landscape orientation - camera is held horizontally. */
  LANDSCAPE
}

/* Position of camera on the device. */
enum CameraPosition
{
  /* Camera is on the front of the device.  Used for selfie captures. */
  FRONT,

  /* Camera is on the back of the device.  Used for capturing other subjects. */
  BACK
}

/* The type of JSON request package to send to the Face Liveness back-end. */
enum PackageType
{
  /*Request focused on high usability when analyzing on the back-end. */
  HIGH_USABILITY,

  /* Request focused on a balance of usability and security when analyzing on the back-end. */
  BALANCED,

  /* Request focused on high security when analyzing on the back-end. */
  HIGH_SECURITY
}

/* The status of the currently running capture session. */
enum CaptureSessionStatus
{
  /* The capture session is currently idle and is not ready
       to start the capture session. */
  IDLE,

  /* The capture session is starting. */
  STARTING,

  /* The capture session is currently capturing. */
  CAPTURING,

  /* The capture session has completed capturing and is completing final
       tasks.  Results will be available upon receiving the COMPLETED
       status. */
  POST_CAPTURE_PROCESSING,

  /* The capture session has successfully completed.  Results are
       available. */
  COMPLETED,

  /* An error occurred within the camera before the capture session could
       complete.  No results available. */
  ABORTED,

  /* The capture session has been ended via the stop capture API call.  No
       results available. */
  STOPPED,

  /* The capture session has ended after attempting to capture for the
       specified timeout duration.  No results available. */
  TIMED_OUT
}

/* Feedback related to the current status of the subject. */
enum AutoCaptureFeedback
{
  /* The subject's face was compliant. */
  FACE_COMPLIANT,

  /* No faces were detected in the image.  The subject's face must be
         wholly in frame. */
  NO_FACE_DETECTED,

  /* Multiple faces were detected in the image.  The subject must be the
         only face in frame. */
  MULTIPLE_FACES_DETECTED,

  /* The subject's pose is too far off center.  The subject should
         directly face the camera. */
  INVALID_POSE,

  /* The subject's face is too far away.  The subject should move closer
         to the camera. */
  FACE_TOO_FAR,

  /* The subject's face is too close.  The subject should move away from
         the camera. */
  FACE_TOO_CLOSE,

  /* The subject's face is too far to the left.  The subject should move
         to the center of the frame. */
  FACE_ON_LEFT,

  /* The subject's face is too far to the right.  The subject should move
         to the center of the frame. */
  FACE_ON_RIGHT,

  /* The subject's face is too high.  The subject should move down towards
         the center of the frame. */
  FACE_TOO_HIGH,

  /* The subject's face is too low.  The subject should move up towards
         the center of the frame. */
  FACE_TOO_LOW,

  /* There is insufficient lighting.  The subject should move to an area
         with more uniform lighting. */
  INSUFFICIENT_LIGHTING,

  /* The subject's left eye is closed.  The subject should have both eyes
         open and visible to the camera. */
  LEFT_EYE_CLOSED,

  /* The subject's right eye is closed.  The subject should have both eyes
         open and visible to the camera. */
  RIGHT_EYE_CLOSED,

  /* The subject is wearing dark or tinted glasses.  The subject should
         remove the dark or tinted glasses. */
  DARK_GLASSES_DETECTED
}

//******************** Private *********************//
final DynamicLibrary dylib = Platform.isAndroid
    ? DynamicLibrary.open("libface_capture.so")
    : DynamicLibrary.process();

//******** face_capture_create ********
class CaptureCreateWrapper extends Struct {
  @Int32()
  external int? libId;

  @Int32()
  external int? error;
}

typedef FaceCaptureCreateFunc = CaptureCreateWrapper Function();
typedef FaceCaptureCreate = CaptureCreateWrapper Function();
FaceCaptureCreate _faceCaptureCreate = dylib
    .lookup<NativeFunction<FaceCaptureCreateFunc>>('face_capture_create')
    .asFunction<FaceCaptureCreate>();

int __aware_interop_private_faceCaptureCreate() {
  CaptureCreateWrapper val = _faceCaptureCreate();

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  return val.libId!;
}

//******** face_capture_destroy ********
typedef FaceCaptureDestroyFunc = Void Function(Int32 libId);
typedef FaceCaptureDestroy = void Function(int libId);
FaceCaptureDestroy _faceCaptureDestroy = dylib
    .lookup<NativeFunction<FaceCaptureDestroyFunc>>('face_capture_destroy')
    .asFunction<FaceCaptureDestroy>();

void __aware_interop_private_faceCaptureDispose(int libId) {
  _faceCaptureDestroy(libId);
}

//******** face_capture_workflow_create ********
class WorkflowCreateWrapper extends Struct {
  @Int32()
  external int? libId;

  @Int32()
  external int? workflowId;

  @Int32()
  external int? error;
}

typedef FaceCaptureWorkflowCreateFunc = WorkflowCreateWrapper Function(Int32 libId, Pointer<Utf8> workflowName);
typedef FaceCaptureWorkflowCreate = WorkflowCreateWrapper Function(int libId, Pointer<Utf8> workflowName);
FaceCaptureWorkflowCreate _faceCaptureWorkflowCreate = dylib
    .lookup<NativeFunction<FaceCaptureWorkflowCreateFunc>>('face_capture_workflow_create')
    .asFunction<FaceCaptureWorkflowCreate>();

Workflow __aware_interop_private_faceCaptureWorkflowCreate(int libId, Pointer<Utf8> workflowName) {
  WorkflowCreateWrapper val = _faceCaptureWorkflowCreate(libId, workflowName);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  return Workflow(val.libId!, val.workflowId!);
}

//******** face_capture_workflow_destroy ********
typedef FaceCaptureWorkflowDestroyFunc = Int32 Function(Int32 libId, Int32 wfId);
typedef FaceCaptureWorkflowDestroy = int Function(int libId, int wfId);
FaceCaptureWorkflowDestroy _faceCaptureWorkflowDestroy = dylib
    .lookup<NativeFunction<FaceCaptureWorkflowDestroyFunc>>('face_capture_workflow_destroy')
    .asFunction<FaceCaptureWorkflowDestroy>();

void __aware_interop_private_faceCaptureWorkflowDispose(int libId, int wfId) {
  int error = _faceCaptureWorkflowDestroy(libId, wfId);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}

//******** face_capture_workflow_set_property_string ********
typedef FaceCaptureWorkflowSetPropertyStringFunc = Int32 Function(Int32 libId, Int32 wfId, Int8 property, Pointer<Utf8> stringProperty);
typedef FaceCaptureWorkflowSetPropertyString = int Function(int libId, int wfId, int property, Pointer<Utf8> stringProperty);
FaceCaptureWorkflowSetPropertyString _faceCaptureWorkflowSetPropertyString = dylib
    .lookup<NativeFunction<FaceCaptureWorkflowSetPropertyStringFunc>>('face_capture_workflow_set_property_string')
    .asFunction<FaceCaptureWorkflowSetPropertyString>();

void __aware_interop_private_faceCaptureWorkflowSetPropertyString(int libId, int wfId, int property, Pointer<Utf8> stringProperty) {
  int error = _faceCaptureWorkflowSetPropertyString(libId, wfId, property, stringProperty);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}

//******** face_capture_workflow_set_property_double ********
typedef FaceCaptureWorkflowSetPropertyDoubleFunc = Int32 Function(Int32 libId, Int32 wfId, Int8 property, Double doubleProperty);
typedef FaceCaptureWorkflowSetPropertyDouble = int Function(int libId, int wfId, int property, double doubleProperty);
FaceCaptureWorkflowSetPropertyDouble _faceCaptureWorkflowSetPropertyDouble = dylib
    .lookup<NativeFunction<FaceCaptureWorkflowSetPropertyDoubleFunc>>('face_capture_workflow_set_property_double')
    .asFunction<FaceCaptureWorkflowSetPropertyDouble>();

void __aware_interop_private_faceCaptureWorkflowSetPropertyDouble(int libId, int wfId, int property, double doubleProperty) {
  int error = _faceCaptureWorkflowSetPropertyDouble(libId, wfId, property, doubleProperty);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}

//******** face_capture_get_capture_session_state
class SessionStateWrapper extends Struct {
  @Int32()
  external int? libId;

  @Int32()
  external int? stateId;

  @Int32()
  external int? error;
}

typedef FaceCaptureGetCaptureSessionStateFunc = SessionStateWrapper Function(Int32 libId);
typedef FaceCaptureGetCaptureSessionState = SessionStateWrapper Function(int libId);
FaceCaptureGetCaptureSessionState _faceCaptureGetCaptureSessionState = dylib
    .lookup<NativeFunction<FaceCaptureGetCaptureSessionStateFunc>>('face_capture_get_capture_session_state')
    .asFunction<FaceCaptureGetCaptureSessionState>();

CaptureSessionState __aware_interop_private_faceCaptureGetCaptureSessionState(int libId) {
  SessionStateWrapper val = _faceCaptureGetCaptureSessionState(libId);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  return CaptureSessionState(val.libId!, val.stateId!);
}

//******** face_capture_session_state_destroy ********
typedef FaceCaptureStateDestroyFunc = Int32 Function(Int32 libId, Int32 ssId);
typedef FaceCaptureStateDestroy = int Function(int libId, int ssId);
FaceCaptureStateDestroy _faceCaptureStateDestroy = dylib
    .lookup<NativeFunction<FaceCaptureStateDestroyFunc>>('face_capture_session_state_destroy')
    .asFunction<FaceCaptureStateDestroy>();

void __aware_interop_private_faceCaptureSessionStateDispose(int libId, int ssId) {
  int error = _faceCaptureStateDestroy(libId, ssId);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}

//******** face_capture_get_camera_list ********
class CameraListWrapper extends Struct {
  external Pointer<Int32>? ids;

  @Int32()
  external int size;

  @Int32()
  external int? error;
}

typedef FaceCaptureGetCameraListFunc = CameraListWrapper Function(Int32 libId, Int8 position);
typedef FaceCaptureGetCameraList = CameraListWrapper Function(int libId, int position);
FaceCaptureGetCameraList _faceCaptureGetCameraList = dylib
    .lookup<NativeFunction<FaceCaptureGetCameraListFunc>>('face_capture_get_camera_list')
    .asFunction<FaceCaptureGetCameraList>();

List __aware_interop_private_faceCaptureGetCameraList(int libId, int position) {
  CameraListWrapper val = _faceCaptureGetCameraList(libId, position);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  var growableList = [];
  growableList.length = 0;

  for(int i=0; i<val.size; i++) {
    growableList.add(Camera(libId, val.ids![i]));
  }

  return growableList;
}

//******** face_capture_camera_destroy ********
typedef FaceCaptureCameraDestroyFunc = Int32 Function(Int32 libId, Int32 camId);
typedef FaceCaptureCameraDestroy = int Function(int libId, int camId);
FaceCaptureCameraDestroy _faceCaptureCameraDestroy = dylib
    .lookup<NativeFunction<FaceCaptureCameraDestroyFunc>>('face_capture_camera_destroy')
    .asFunction<FaceCaptureCameraDestroy>();

void __aware_interop_private_faceCaptureCameraDispose(int libId, int camId) {

  int error = _faceCaptureCameraDestroy(libId, camId);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}

//******** face_capture_start_capture_session ********
typedef FaceCaptureStartCaptureSessionFunc = Int32 Function(Int32 libId, Int32 wfId, Int32 camId);
typedef FaceCaptureStartCaptureSession = int Function(int libId, int wfId, int camId);
FaceCaptureStartCaptureSession _faceCaptureStartCaptureSession = dylib
    .lookup<NativeFunction<FaceCaptureStartCaptureSessionFunc>>('face_capture_start_capture_session')
    .asFunction<FaceCaptureStartCaptureSession>();

void __aware_interop_private_faceCaptureStartCaptureSession(int libId, int wfId, int camId) {

  int error = _faceCaptureStartCaptureSession(libId, wfId, camId);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}

//******** face_capture_stop_capture_session ********
typedef FaceCaptureStopCaptureSessionFunc = Int32 Function(Int32 libId);
typedef FaceCaptureStopCaptureSession = int Function(int libId);
FaceCaptureStopCaptureSession _faceCaptureStopCaptureSession = dylib
    .lookup<NativeFunction<FaceCaptureStopCaptureSessionFunc>>('face_capture_stop_capture_session')
    .asFunction<FaceCaptureStopCaptureSession>();

void __aware_interop_private_faceCaptureStopCaptureSession(int libId) {

  int error = _faceCaptureStopCaptureSession(libId);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}

//******** get_session_roi ********
class SessionRoi extends Struct {
  @Int32()
  external int roi_x;

  @Int32()
  external int roi_y;

  @Int32()
  external int roi_width;

  @Int32()
  external int roi_height;

  @Int32()
  external int? error;
}

typedef FaceCaptureGetCaptureSessionRoiFunc = SessionRoi Function(Int32 libId);
typedef FaceCaptureGetCaptureSessionRoi = SessionRoi Function(int libId);
FaceCaptureGetCaptureSessionRoi _getCaptureSessionRoi = dylib
    .lookup<NativeFunction<FaceCaptureGetCaptureSessionRoiFunc>>('face_capture_get_capture_session_roi')
    .asFunction<FaceCaptureGetCaptureSessionRoi>();

CaptureSessionRoi __aware_interop_private_getFaceCaptureSessionRoi(int libId, CaptureSessionRoi roi) {
  SessionRoi val =_getCaptureSessionRoi(libId);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  roi.roiX = val.roi_x;
  roi.roiY = val.roi_y;
  roi.roiWidth = val.roi_width;
  roi.roiHeight = val.roi_height;

  return roi;
}

//******** get_session_status ********
class SessionStatus extends Struct {
  @Int32()
  external int status;

  @Int32()
  external int? error;
}

typedef FaceCaptureGetCaptureSessionStatusFunc = SessionStatus Function(Int32 libId, Int32 stateId);
typedef FaceCaptureGetCaptureSessionStatus = SessionStatus Function(int libId, int stateId);
FaceCaptureGetCaptureSessionStatus _getCaptureSessionStatus = dylib
    .lookup<NativeFunction<FaceCaptureGetCaptureSessionStatusFunc>>('face_capture_get_capture_session_status')
    .asFunction<FaceCaptureGetCaptureSessionStatus>();

CaptureSessionStatus  __aware_interop_private_getFaceCaptureSessionStatus(int libId, int stateId) {
  SessionStatus val =_getCaptureSessionStatus(libId, stateId);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  return getCaptureSessionStatusValue(val.status);
}

CaptureSessionStatus  getCaptureSessionStatusValue(int status) {

  switch(status) {
    case 0:
      return CaptureSessionStatus.IDLE;
    case 1:
      return CaptureSessionStatus.STARTING;
    case 2:
      return CaptureSessionStatus.CAPTURING;
    case 3:
      return CaptureSessionStatus.POST_CAPTURE_PROCESSING;
    case 4:
      return CaptureSessionStatus.COMPLETED;
    case 5:
      return CaptureSessionStatus.ABORTED;
    case 6:
      return CaptureSessionStatus.STOPPED;
    case 7:
      return CaptureSessionStatus.TIMED_OUT;
    default:
      return CaptureSessionStatus.IDLE;
  }
}

//******** face_capture_get_capture_session_feedback ********
class SessionFeedback extends Struct {
  @Int32()
  external int? feedback;

  @Int32()
  external int? error;
}

typedef FaceCaptureGetCaptureSessionFeedbackFunc = SessionFeedback Function(Int32 libId, Int32 stateId);
typedef FaceCaptureGetCaptureSessionFeedback = SessionFeedback Function(int libId, int stateId);
FaceCaptureGetCaptureSessionFeedback _getCaptureSessionFeedback = dylib
    .lookup<NativeFunction<FaceCaptureGetCaptureSessionFeedbackFunc>>('face_capture_get_capture_session_feedback')
    .asFunction<FaceCaptureGetCaptureSessionFeedback>();

AutoCaptureFeedback __aware_interop_private_getFaceCaptureSessionFeedback(int libId, int stateId) {
  SessionFeedback val = _getCaptureSessionFeedback(libId, stateId);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  return getCaptureSessionFeedbackValue(val.feedback!);
}

AutoCaptureFeedback getCaptureSessionFeedbackValue(int feedback) {

  switch(feedback) {
    case 0:
      return AutoCaptureFeedback.FACE_COMPLIANT;
    case 1:
      return AutoCaptureFeedback.NO_FACE_DETECTED;
    case 2:
      return AutoCaptureFeedback.MULTIPLE_FACES_DETECTED;
    case 3:
      return AutoCaptureFeedback.INVALID_POSE;
    case 4:
      return AutoCaptureFeedback.FACE_TOO_FAR;
    case 5:
      return AutoCaptureFeedback.FACE_TOO_CLOSE;
    case 6:
      return AutoCaptureFeedback.FACE_ON_LEFT;
    case 7:
      return AutoCaptureFeedback.FACE_ON_RIGHT;
    case 8:
      return AutoCaptureFeedback.FACE_TOO_HIGH;
    case 9:
      return AutoCaptureFeedback.FACE_TOO_LOW;
    case 10:
      return AutoCaptureFeedback.INSUFFICIENT_LIGHTING;
    case 11:
      return AutoCaptureFeedback.LEFT_EYE_CLOSED;
    case 12:
      return AutoCaptureFeedback.RIGHT_EYE_CLOSED;
    case 13:
      return AutoCaptureFeedback.DARK_GLASSES_DETECTED;
    default:
      return AutoCaptureFeedback.NO_FACE_DETECTED;
  }
}

//******** face_capture_get_server_package ********
class ServerPackageStr extends Struct {
  external Pointer<Uint8>? data;

  @Int32()
  external int? size;

  @Int32()
  external int? error;

  void destroy(){
    _freeMemory(data!);
  }
}

typedef FaceCaptureGetServerPackageFunc = ServerPackageStr Function(Int32 libId, Int32 wfId, Int32 packageType);
typedef FaceCaptureGetServerPackage = ServerPackageStr Function(int libId, int wfId, int packageType);
FaceCaptureGetServerPackage _faceCaptureGetServerPackage = dylib
    .lookup<NativeFunction<FaceCaptureGetServerPackageFunc>>('face_capture_get_server_package')
    .asFunction<FaceCaptureGetServerPackage>();

String __aware_interop_private_getFaceCaptureServerPackage(int libId, int wfId, int packageType) {

  ServerPackageStr val = _faceCaptureGetServerPackage(libId, wfId, packageType);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  var strPackage = String.fromCharCodes(val.data!.asTypedList(val.size!));
  val.destroy();

  return strPackage;
}

//******** face_capture_camera_get_name ********
class CameraNameStr extends Struct {
  external Pointer<Uint8>? data;

  @Int32()
  external int? size;

  @Int32()
  external int? error;

  void destroy(){
    _freeMemory(data!);
  }
}

class CameraName {
  Pointer<Uint8> data;

  int size;

  CameraName(this.data, this.size);
}

typedef FaceCaptureGetCameraNameFunc = CameraNameStr Function(Int32 libId, Int32 camId);
typedef FaceCaptureGetCameraName = CameraNameStr Function(int libId, int camId);
FaceCaptureGetCameraName _faceCaptureGetCameraName = dylib
    .lookup<NativeFunction<FaceCaptureGetCameraNameFunc>>('face_capture_camera_get_name')
    .asFunction<FaceCaptureGetCameraName>();

String __aware_interop_private_faceCaptureGetCameraName(int libId, int camId) {

  CameraNameStr val = _faceCaptureGetCameraName(libId, camId);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  var strName = String.fromCharCodes(val.data!.asTypedList(val.size!));
  val.destroy();

  return strName;
}

//******** face_capture_camera_set_orientation ********
typedef FaceCaptureSetCameraOrientationFunc = Int32 Function(Int32 libId, Int32 camId, Int8 orientation);
typedef FaceCaptureSetCameraOrientation = int Function(int libId, int camId, int orientation);
FaceCaptureSetCameraOrientation _faceCaptureSetCameraOrientation = dylib
    .lookup<NativeFunction<FaceCaptureSetCameraOrientationFunc>>('face_capture_camera_set_orientation')
    .asFunction<FaceCaptureSetCameraOrientation>();

void __aware_interop_private_faceCaptureSetCameraOrientation(int libId, int camId, int orientation) {
  int error = _faceCaptureSetCameraOrientation(libId, camId, orientation);

  if(error != 0) {
    throw FaceCaptureException(error, getFaceCaptureErrorDetails(error));
  }
}


//******** face_capture_get_session_frame ********
class FrameBuffer extends Struct {
  external Pointer<Uint8>? data;

  @Int32()
  external int? size;

  @Int32()
  external int? error;

  void destroy(){
    _freeMemory(data!);
  }
}

typedef GetSessionFrameFunc = FrameBuffer Function(Int32 libId, Int32 stateId);
typedef GetSessionFrame = FrameBuffer Function(int libId, int stateId);
GetSessionFrame _getSessionFrame = dylib
    .lookup<NativeFunction<GetSessionFrameFunc>>('face_capture_get_session_frame')
    .asFunction<GetSessionFrame>();

Uint8List __aware_interop_private_getFaceCaptureSessionFrame(int libId, int stateId) {

  FrameBuffer val = _getSessionFrame(libId, stateId);

  if(val.error != 0) {
    throw FaceCaptureException(val.error!, getFaceCaptureErrorDetails(val.error!));
  }

  final original = val.data!.asTypedList(val.size!);
  Uint8List blobBytes = Uint8List.fromList(original);

  val.destroy();

  return blobBytes;
}

//******** face_capture_get_error_details ********
class ErrorDetailsStr extends Struct {
  external Pointer<Uint8>? data;

  @Int32()
  external int? size;

  @Int32()
  external int? error;

  void destroy(){
    _freeMemory(data!);
  }
}

typedef FaceCaptureGetErrorDetailsFunc = ErrorDetailsStr Function(Int32 code);
typedef FaceCaptureGetErrorDetails = ErrorDetailsStr Function(int code);
FaceCaptureGetErrorDetails _faceCaptureGetErrorDetails = dylib
    .lookup<NativeFunction<FaceCaptureGetErrorDetailsFunc>>('face_capture_get_error_details')
    .asFunction<FaceCaptureGetErrorDetails>();

String getFaceCaptureErrorDetails(int code) {

  var strErrorDetails = "";
  ErrorDetailsStr val = _faceCaptureGetErrorDetails(code);

  if(val.error != 0) {
    if(val.error == AW_FACE_CAPTURE_E_OUT_OF_MEMORY) {
      strErrorDetails = "The library failed to allocate memory.";
    } else {
      strErrorDetails = "Unknown error code.";
    }
  }

  strErrorDetails = String.fromCharCodes(val.data!.asTypedList(val.size!));
  val.destroy();

  return strErrorDetails;
}

//******** get_version ********
typedef GetVersionFunc = Int32 Function();
typedef GetVersion = int Function();
GetVersion _getVersion = dylib
    .lookup<NativeFunction<GetVersionFunc>>('get_version')
    .asFunction<GetVersion>();

int __aware_interop_private_getFaceCaptureVersionInt() {
  return _getVersion();
}

//******** get_version_string ********
class VersionStr extends Struct {
  external Pointer<Uint8>? data;

  @Int32()
  external int? size;
}

typedef GetVersionStringFunc = VersionStr Function();
typedef GetVersionString = VersionStr Function();
GetVersionString _getVersionString = dylib
    .lookup<NativeFunction<GetVersionStringFunc>>('get_version_string')
    .asFunction<GetVersionString>();

String __aware_interop_private_getFaceCaptureVersionString() {

  VersionStr val = _getVersionString();
  String strVersion = String.fromCharCodes(val.data!.asTypedList(val.size!));

  return strVersion;
}

//******** face_capture_free ********
typedef FreeMemoryFunc = Void Function(Pointer<Uint8> data);
typedef FreeMemory = void Function(Pointer<Uint8> data);
FreeMemory _freeMemory = dylib
    .lookup<NativeFunction<FreeMemoryFunc>>('face_capture_free')
    .asFunction<FreeMemory>();

void freeMemory(Pointer<Uint8> data) {
  _freeMemory(data);
}
