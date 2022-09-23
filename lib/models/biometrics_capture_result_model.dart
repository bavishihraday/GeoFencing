import 'dart:typed_data';

class BiometricsCaptureResult {
  final Uint8List capturedBytes;
  final String serverPackage;

  BiometricsCaptureResult(this.capturedBytes, this.serverPackage);
}