import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:fairticketsolutions_demo_app/constants/http_base_urls.dart';
import 'package:fairticketsolutions_demo_app/models/biosp_enums.dart';
import 'package:flutter/foundation.dart';

import '../models/biosp_server_models.dart';

import 'package:http/http.dart' as http;

class BioSPEvent {

  static String serverBaseString = kBiospEventBaseUrl;
  static Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*/*",
    HttpHeaders.authorizationHeader: "Basic a25vbWk6TlZVITQ5NyM=",
    HttpHeaders.acceptEncodingHeader: "gzip, deflate",
    HttpHeaders.connectionHeader: "Keep-Alive"
  };

  // Sync operations

  static Future<EventSyncResult?> sync(String externalId) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/syncServices/sync");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode({ "ids": [externalId] })
      );

      debugPrint("~~SYNC BIOSP~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? EventSyncResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~SYNC BIOSP~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<EventSyncStatusResult?> syncStatus(int jobId) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/syncServices/status");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode({ "jobId": jobId.toString() })
      );

      debugPrint("~~GET SYNC STATUS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? EventSyncStatusResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~GET SYNC STATUS~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<EventSyncResult?> resumeSync(int jobId) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/syncServices/sync");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode({ "jobId": jobId.toString() })
      );

      debugPrint("~~RESUME BIOSP SYNC~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? EventSyncResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~RESUME BIOSP SYNC~~\nHttp Error: $e");

      return null;
    }
  }

  // Biometrics matching

  static Future<VerifyBiometricsResult?> verifyBiometrics(Uint8List probeBlob, Uint8List knownBlob, MatchType matchType) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/biometricsVerificationMatcherService/verifyBiometrics");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode(VerifyBiometricsRequest(probeBlob: probeBlob, knownBlob: knownBlob, matchType: matchType).toEncodable())
      );

      debugPrint("~~VERIFY BIOMETRICS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? VerifyBiometricsResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~VERIFY BIOMETRICS~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<CheckLivenessResult?> checkFaceLiveness(String serverPackage) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/livenessAnalyzerService/analyze_video");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: serverPackage
      );

      debugPrint("~~CHECK FACE LIVENESS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? CheckLivenessResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~CHECK FACE LIVENESS~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<CheckLivenessResult?> checkVoiceLiveness(String serverPackage, String phrase) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/voiceAnalyzerService/analyze");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode(CheckVoiceLivenessRequest(jsonDecode(serverPackage), phrase).toEncodable())
      );

      debugPrint("~~CHECK VOICE LIVENESS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? CheckLivenessResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~CHECK VOICE LIVENESS~~\nHttp Error: $e");

      return null;
    }
  }

  // Gallery matching

  static Future<VerifyBiometricsResult?> verifySubjectInGallery(String externalId, Uint8List probeBlob, String? phrase) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectIndependentMatcherService/verifySubjectInGallery");
    http.Response response;

    String json = jsonEncode(SubjectInGalleryRequest(probeBlob, phrase: phrase, externalId: externalId).toEncodable());

    try {
      response = await http.post(
        uri,
        headers: requestHeaders,
        body: json
      );

      debugPrint("~~VERIFY SUBJECT IN GALLERY~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? VerifyBiometricsResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~VERIFY SUBJECT IN GALLERY~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<IdentifySubjectInGalleryResult?> identifySubjectInGallery(Uint8List probeBlob, String? phrase) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectIndependentMatcherService/identifySubjectInGallery");
    http.Response response;

    try {
      response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(SubjectInGalleryRequest(probeBlob, phrase: phrase).toEncodable())
      );

      debugPrint("~~IDENTIFY SUBJECT IN GALLERY~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? IdentifySubjectInGalleryResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~IDENTIFY SUBJECT IN GALLERY~~\nHttp Error: $e");

      return null;
    }
  }
}