import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fairticketsolutions_demo_app/constants/http_base_urls.dart';
import 'package:fairticketsolutions_demo_app/models/biosp_enums.dart';
import 'package:flutter/foundation.dart';

import '../models/biosp_server_models.dart';

import 'package:http/http.dart' as http;

class BioSPCentral {

  static String serverBaseString = kBiospCentralBaseUrl;
  static Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "*/*",
    HttpHeaders.authorizationHeader: "Basic a25vbWk6TlZVITQ5NyM=",
    HttpHeaders.acceptEncodingHeader: "gzip, deflate",
    HttpHeaders.connectionHeader: "Keep-Alive"
  };

  static Future<AddSubjectResult?> addSubject(String externalId, String? firstName, String? middleName, String? lastName) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectManagerService/addSubject");
    http.Response response;

    try {
      response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(AddSubjectRequest(externalId: externalId, firstName: firstName, middleName: middleName, lastName: lastName).toEncodable())
      );

      debugPrint("~~ADD SUBJECT~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? AddSubjectResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~ADD SUBJECT~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<AddSubjectResult?> addSubjectDataFace(String externalId, String? firstName, String? middleName, String? lastName, List<Uint8List?> imageBlobs) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectManagerService/addSubjectData");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode(AddSubjectDataFaceRequest(externalId: externalId, firstName: firstName, middleName: middleName, lastName: lastName, imageBlobs: imageBlobs).toEncodable())
      );

      debugPrint("~~ADD SUBJECT DATA FACE~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? AddSubjectResult(jsonDecode(response.body)) : null; // Result is the same as addSubject
    } on HttpException catch (e) {
      debugPrint("~~ADD SUBJECT DATA FACE~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<AddSubjectResult?> addSubjectDataVoice(String externalId, String? firstName, String? middleName, String? lastName, List<VoicePackage> voicePackages) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectManagerService/addSubjectData");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode(AddSubjectDataVoiceRequest(externalId: externalId, firstName: firstName, middleName: middleName, lastName: lastName, voicePackages: voicePackages).toEncodable())
      );

      debugPrint("~~ADD SUBJECT DATA VOICE~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? AddSubjectResult(jsonDecode(response.body)) : null; // Result is the same as addSubject
    } on HttpException catch (e) {
      debugPrint("~~ADD SUBJECT DATA VOICE~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<AddBiometricsResult?> addBiometrics(String externalId, Uint8List imageBlob) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectManagerService/addBiometrics");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode(AddBiometricsRequest(externalId: externalId, imageBlobs: [imageBlob]).toEncodable())
      );
      
      debugPrint("~~ADD BIOMETRICS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? AddBiometricsResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~ADD BIOMETRICS~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<RetrieveSubjectResult?> retrieveSubject(String externalId) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectManagerService/retrieveSubjects");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode({ "externalId": externalId }) // This doesn't need a class unto itself
      );

      debugPrint("~~RETRIEVE SUBJECT~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? RetrieveSubjectResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~RETRIEVE SUBJECT~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<RetrieveBiometricsResult?> retrieveBiometrics(String externalId, String? phrase) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectManagerService/retrieveBiometrics");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode(RetrieveBiometricsRequest(externalId: externalId, phrase: phrase).toEncodable())
      );

      debugPrint("~~RETRIEVE BIOMETRICS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? RetrieveBiometricsResult(jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~RETRIEVE BIOMETRICS~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<StatusMessagesListModel?> deleteSubject(String externalId) async {
    Uri uri = Uri.parse("$serverBaseString/BioSP/rest/subjectManagerService/deleteSubject");
    http.Response response;

    try {
      response = await http.post(
          uri,
          headers: requestHeaders,
          body: jsonEncode({ "externalId": externalId })
      );

      debugPrint("~~DELETE SUBJECT~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? StatusMessagesListModel(jsonDecode(response.body)["statusMessages"]) : null;
    } on HttpException catch (e) {
      debugPrint("~~DELETE SUBJECT~~\nHttp Error: $e");

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

  // Used before event server is introduced into the workflow
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
}