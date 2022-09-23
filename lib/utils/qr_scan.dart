import 'dart:io';
import 'package:fairticketsolutions_demo_app/utils/image_utils.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class QrScan {
  // QRs are verified if they are present for now
  static Future<bool> verifyQr() async {
    final File? pickedFile = await ImageUtils.pickImage();

    if (pickedFile != null) {
      final InputImage inputImage = InputImage.fromFile(pickedFile);
      final BarcodeScanner barcodeScanner = BarcodeScanner(formats: [ BarcodeFormat.qrCode ]);
      final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

      String? barcodeResult = barcodes.isNotEmpty ? barcodes[0].displayValue : null;

      barcodeScanner.close();
      return barcodeResult != null && barcodeResult.isNotEmpty;
    }

    return false;
  }
}