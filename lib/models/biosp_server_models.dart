import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:fairticketsolutions_demo_app/models/biosp_enums.dart';

// Central server

class AddSubjectRequest {
  final String populationName = "defaultpopulation";

  late String externalId;

  String? fullName;
  String? firstName;
  String? middleName;
  String? lastName;

  AddSubjectRequest({required this.externalId, this.firstName, this.middleName, this.lastName}) {
    // Some people don't have middle names, handle that
    if (firstName != null && lastName != null) {
      fullName = middleName != null ? "$firstName $middleName $lastName" : "$firstName $lastName";
    }
  }

  // Converts to something jsonEncode() can work with
  Map<String, dynamic> toEncodable() {
    return {
      "externalId": externalId,
      "fullName": fullName,
      "firstName": firstName,
      "middleName": middleName,
      "lastName": lastName,
      "populationName": populationName
    }..removeWhere((key, value) => value == null); // Since some types are nullable, remove them to not cause problems with BioSP
  }
}

class AddSubjectResult {
  late Map<String, dynamic> json;

  List<StatusMessageModel> statusMessages = [];
  int? biospSubjectId;
  String? externalId;
  String? govId;
  String? idmId;
  String? fullName;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? populationName;

  AddSubjectResult(this.json) {
    for (var element in json["statusMessages"]) {
      statusMessages.add(StatusMessageModel(element));
    }
    biospSubjectId = json["subjectIdentifier"]["biospSubjectId"];
    externalId = json["subjectIdentifier"]["externalId"];
    govId = json["subjectIdentifier"]["govId"];
    idmId = json["subjectIdentifier"]["idmId"];
    fullName = json["subjectIdentifier"]["fullName"];
    firstName = json["subjectIdentifier"]["firstLastName"]["firstName"];
    lastName = json["subjectIdentifier"]["firstLastName"]["lastName"];
    dateOfBirth = json["subjectIdentifier"]["dateOfBirth"];
    populationName = json["subjectIdentifier"]["populationName"];
  }
}

// These are here for easy re-use
class StatusMessageModel {
  late Map<String, dynamic> json;

  String? name;
  String? message;
  String? level;

  StatusMessageModel(this.json) {
    name = json["name"];
    message = json["message"];
    level = json["level"];
  }
}

class AddSubjectDataFaceRequest {
  final String populationName = "defaultpopulation";
  final String addSubjectIfNotExist = "true";

  late String externalId;

  String? fullName;
  String? firstName;
  String? middleName;
  String? lastName;
  List<Uint8List?>? imageBlobs;

  AddSubjectDataFaceRequest({required this.externalId, this.firstName, this.middleName, this.lastName, this.imageBlobs}) {
    // Some people don't have middle names, handle that
    if (firstName != null && lastName != null) {
      fullName = middleName != null ? "$firstName $middleName $lastName" : "$firstName $lastName";
    }
  }

  // Converts to something jsonEncode() can work with
  Map<String, dynamic> toEncodable() {
    return {
      "subjectIdentifier": {
        "externalId": externalId,
        "populationName": populationName
      },
      "processingOption": {
        "addSubjectIfNotExist": addSubjectIfNotExist
      },
      "subjectData": {
        "biometrics": BiometricsModel(imageBlobs: imageBlobs).toEncodable(),
        "subjectAttributes": {
          "externalId": externalId,
          "fullName": fullName,
          "firstName": firstName,
          "middleName": middleName,
          "lastName": lastName
        }
      }
    }..removeWhere((key, value) => value == null); // Since some types are nullable, remove them to not cause problems with BioSP
  }
}

class AddSubjectDataVoiceRequest {
  final String populationName = "defaultpopulation";
  final String addSubjectIfNotExist = "true";

  late String externalId;

  String? fullName;
  String? firstName;
  String? middleName;
  String? lastName;
  List<VoicePackage>? voicePackages;

  AddSubjectDataVoiceRequest({required this.externalId, this.firstName, this.middleName, this.lastName, this.voicePackages}) {
    // Some people don't have middle names, handle that
    if (firstName != null && lastName != null) {
      fullName = middleName != null ? "$firstName $middleName $lastName" : "$firstName $lastName";
    }
  }

  // Converts to something jsonEncode() can work with
  Map<String, dynamic> toEncodable() {
    return {
      "subjectIdentifier": {
        "externalId": externalId,
        "populationName": populationName
      },
      "processingOption": {
        "addSubjectIfNotExist": addSubjectIfNotExist
      },
      "subjectData": {
        "biometrics": BiometricsModel(voicePackages: voicePackages).toEncodable(),
        "subjectAttributes": {
          "externalId": externalId,
          "fullName": fullName,
          "firstName": firstName,
          "middleName": middleName,
          "lastName": lastName
        }
      }
    }..removeWhere((key, value) => value == null); // Since some types are nullable, remove them to not cause problems with BioSP
  }
}

// Broken up to be re-used easily
class BiometricsModel {
  final String pose = "FRONT";
  final String compressionAlgorithm = "JPG";

  Map<String, dynamic>? json;
  List<Uint8List?>? imageBlobs; // For if multiple facialImages come back
  List<VoicePackage>? voicePackages;

  Map<String, dynamic>? fingerprintImages;
  Map<String, dynamic>? fingerprintTemplates;
  Map<String, dynamic>? palmprintImages;
  Map<String, dynamic>? latentImages;
  Map<String, dynamic>? facialImages;
  Map<String, dynamic>? irisImages;
  Map<String, dynamic>? irisTemplates;
  Map<String, dynamic>? smtImages;
  Map<String, dynamic>? voiceSamples;
  Map<String, dynamic>? voiceTemplates;

  BiometricsModel({this.imageBlobs, this.voicePackages, this.json}) {
    if (json != null) {
      fingerprintImages = json!["fingerprintImages"];
      fingerprintTemplates = json!["fingerprintTemplates"];
      palmprintImages = json!["palmprintImages"];
      latentImages = json!["latentImages"];
      facialImages = json!["facialImages"];
      irisImages = json!["irisImages"];
      irisTemplates = json!["irisTemplates"];
      smtImages = json!["smtImages"];
      voiceSamples = json!["voiceSamples"];
      voiceTemplates = json!["voiceTemplates"];

      if (facialImages != null) {
        List<dynamic> facialImagesList = facialImages!["facialImage"];

        imageBlobs = [];
        for (var element in facialImagesList) {
          imageBlobs!.add(base64Decode(element["image"]));
        }
      }

      if (voiceSamples != null) {
        List<dynamic> voiceSamplesList = voiceSamples!["voiceSample"];

        voicePackages = [];
        for (var element in voiceSamplesList) {
          voicePackages!.add(VoicePackage(phrase: element["phrase"], blob: base64Decode(element["sample"])));
        }
      }
    }
  }

  // Converts to something jsonEncode() can work with
  Map<String, dynamic>? toEncodable() {
    List<Map<String, dynamic>> facialImage = [];
    if (imageBlobs != null) {
      for (Uint8List? imageBlob in imageBlobs!) {
        if (imageBlob != null) {
          facialImage.add({
            "facialImageMetadata": {
              "pose": pose,
              "imageStorage": {
                "compressionAlgorithm": compressionAlgorithm
              }
            },
            "image": base64Encode(imageBlob.toList())
          });
        }
      }
    }

    Map<String, dynamic>? facialImages;
    if (facialImage.isNotEmpty) {
      facialImages = {
        "facialImage": facialImage
      };
    }

    List<Map<String, dynamic>> voiceSample = [];
    if (voicePackages != null) {
      for (VoicePackage? voicePackage in voicePackages!) {
        if (voicePackage != null) {
          voiceSample.add(
            {
              "voiceSampleMetadata": {
                "phrase": voicePackage.phrase,
                "phraseType": "STATIC",
                "language": "ENG",
                "sampleStorage": {
                  "bitRate": 11025,
                  "channelCount": "MONO",
                  "channelSource": "MICROPHONE",
                  "endianness": "SMALL_ENDIAN",
                  "audioFormat": {
                    "containerFormat": "WAV",
                    "codecFormat": "LINEAR_PCM"
                  }
                }
              },
              "sample": base64Encode(voicePackage.blob.toList())
            }
          );
        }
      }
    }

    Map<String, dynamic>? voiceSamples;
    if (voiceSample.isNotEmpty) {
      voiceSamples = {
        "voiceSample": voiceSample
      };
    }

    return {
      "voiceSamples": voiceSamples,
      "facialImages": facialImages
    }..removeWhere((key, value) => value == null);
  }
}

class VoicePackage {
  late String phrase;
  late Uint8List blob;

  VoicePackage({required this.phrase, required this.blob});
}

class AddBiometricsRequest {
  late String externalId;
  late List<Uint8List?>? imageBlobs;

  AddBiometricsRequest({required this.externalId, required this.imageBlobs});

  // Converts to something jsonEncode() can work with
  Map<String, dynamic> toEncodable() {
    return {
      "subjectIdentifier": {
        "externalId": externalId
      },
      "biometrics": BiometricsModel(imageBlobs: imageBlobs).toEncodable(),
    };
  }
}

class AddBiometricsResult {
  late Map<String, dynamic> json;

  List<StatusMessageModel> statusMessages = [];
  int? version;
  
  AddBiometricsResult(this.json) {
    version = json["version"];
    for (var element in json["statusMessages"]) {
      statusMessages.add(StatusMessageModel(element));
    }
  }
}

class RetrieveSubjectResult {
  late Map<String, dynamic> json;

  List<StatusMessageModel> statusMessages = [];
  List<Map<String, dynamic>> subjectAttributes = [];
  int? totalSubjectCount;

  RetrieveSubjectResult(this.json) {
    for (var element in json["statusMessages"]) {
      statusMessages.add(StatusMessageModel(element));
    }
    subjectAttributes = json["subjectAttributes"];
    totalSubjectCount = json["totalSubjectCount"];
  }
}

class RetrieveBiometricsRequest {
  late String externalId;
  late String? phrase;

  RetrieveBiometricsRequest({required this.externalId, this.phrase});

  // Converts to something jsonEncode() can work with
  Map<String, dynamic> toEncodable() {
    Map<String, dynamic> encodable;

    if (phrase != null) {
      encodable = {
        "subjectIdentifier": {
          "externalId": externalId
        },
        "biometricsSelector": {
          "voiceSampleSelector": [
            {
              "phrase": phrase
            },
          ],
        },
      };
    }
    else {
      encodable = {
        "subjectIdentifier": {
          "externalId": externalId
        },
        "biometricsSelector": {
          "facialImageSelector": [
            {
              "compressionAlgorithm": "JPG"
            },
          ],
        },
      };
    }

    return encodable;
  }
}

class RetrieveBiometricsResult {
  late BiometricsModel biometrics;
  late Map<String, dynamic> json;

  List<StatusMessageModel> statusMessages = [];

  RetrieveBiometricsResult(this.json) {
    for (var element in json["statusMessages"]) {
      statusMessages.add(StatusMessageModel(element));
    }
    biometrics = BiometricsModel(json: json["biometrics"]);
  }
}

// Not used in bigger models to make accessing props of them easier
class StatusMessagesListModel {
  List<StatusMessageModel> statusMessages = [];

  StatusMessagesListModel(List<dynamic> list) {
    for (var element in list) {
      statusMessages.add(StatusMessageModel(element));
    }
  }
}

class CheckVoiceLivenessRequest {
  static const String phraseType = "STATIC";

  late Map<String, dynamic> serverPackage;
  late String phrase;

  CheckVoiceLivenessRequest(this.serverPackage, this.phrase);

  Map<String, dynamic> toEncodable() {
    return {
      "voiceSample": [
        {
          "voiceSampleMetadata": {
            "phrase": phrase,
            "phraseType": phraseType
          },
          "sample": serverPackage["voice"]["voiceSamples"][0]["data"]
        }
      ]
    };
  }
}

class CheckLivenessResult {
  late Map<String, dynamic> json;

  List<dynamic>? autocaptureResultFeedback;
  List<dynamic>? livenessResultFeedback;
  bool? capturedFrameIsConstructed;
  Uint8List? capturedFrameBlob;
  double? score;

  CheckLivenessResult(this.json) {
    if (json.containsKey("video")) {
      autocaptureResultFeedback = json["video"]["autocapture_result"]["feedback"];
      livenessResultFeedback = json["video"]["liveness_result"]["feedback"];
      capturedFrameIsConstructed = json["video"]["autocapture_result"]["captured_frame_is_constructed"];
      capturedFrameBlob = base64Decode(json["video"]["autocapture_result"]["captured_frame"]);
      score = json["video"]["liveness_result"]["score"].toDouble();
    }
    else if (json.containsKey("inputVoiceResult")) {
      // :(
      score = json["inputVoiceResult"][0]["voiceSampleMetadata"]["analytics"]["voiceLivenessMetrics"]["humanScore"];
    }
  }
}

// Event server

class EventSyncResult {
  late Map<String, dynamic> json;

  int? jobId;
  String? message;

  EventSyncResult(this.json) {
    jobId = json["jobId"];
    message = json["message"];
  }
}

class EventSyncStatusResult {
  late Map<String, dynamic> json;

  bool? isValid;

  EventSyncStatusResult(this.json) {
    isValid = json["isValid"];
  }
}

class VerifyBiometricsRequest {
  late Uint8List probeBlob;
  late Uint8List knownBlob;
  late MatchType matchType;
  late String phrase;

  VerifyBiometricsRequest({required this.probeBlob, required this.knownBlob, required this.matchType, this.phrase = ""});

  // Converts to something jsonEncode() can work with
  Map<String, dynamic> toEncodable() {
    Map<String, dynamic> encodable;

    if (matchType == MatchType.face) {
      encodable = {
        "matcherName": "aware-nexa-face",
        "probeBiometrics": BiometricsModel(imageBlobs: [probeBlob]).toEncodable(),
        "knownBiometrics": BiometricsModel(imageBlobs: [knownBlob]).toEncodable()
      };
    }
    else if (matchType == MatchType.voice) {
      encodable = {
        "matcherName": "aware-nexavoice",
        "probeBiometrics": BiometricsModel(voicePackages: [VoicePackage(phrase: phrase, blob: probeBlob)]).toEncodable(),
        "knownBiometrics": BiometricsModel(voicePackages: [VoicePackage(phrase: phrase, blob: knownBlob)]).toEncodable()
      };
    }
    else {
      throw Exception("No valid matchType!");
    }

    return encodable;
  }
}

class VerifyBiometricsResult {
  late Map<String, dynamic> json;

  List<StatusMessageModel> statusMessages = [];
  bool? verifyResult;
  double? matchScore;
  int? biometricsMatchedCount;
  int? biometricsOnServer;
  dynamic biometricMatchResultList;
  dynamic matchingMinutia;
  dynamic subjectMatcherData;

  VerifyBiometricsResult(this.json) {
    for (var element in json["statusMessages"]) {
      statusMessages.add(StatusMessageModel(element));
    }
    verifyResult = json["verifyResult"];
    matchScore = json["matchScore"];
    biometricsMatchedCount = json["biometricMatchedCount"];
    biometricsOnServer = json["biometricsOnServer"];
    biometricMatchResultList = json["biometricMatchResultList"];
    matchingMinutia = json["matchingMinutia"];
    subjectMatcherData = json["subjectMatcherData"];
  }
}

// No phrase means this is a face match, no extid means it is identify instead of verify
class SubjectInGalleryRequest {
  final String gallery = "TestGallery";

  late Uint8List probeBlob;

  String? externalId;
  String? phrase;

  SubjectInGalleryRequest(this.probeBlob, { this.externalId, this.phrase });

  Map<String, dynamic> toEncodable() {
    Map<String, dynamic>? sampleBiometrics;

    if (phrase != null) {
      sampleBiometrics = BiometricsModel(voicePackages: [VoicePackage(phrase: phrase!, blob: probeBlob)]).toEncodable();
    }
    else {
      sampleBiometrics = BiometricsModel(imageBlobs: [probeBlob]).toEncodable();
    }

    Map<String, dynamic>? subjectIdentifier;

    if (externalId != null) {
      subjectIdentifier = {
        "externalId": externalId
      };
    }

    return {
      "galleryName": gallery,
      "subjectIdentifier": subjectIdentifier,
      "sampleBiometrics": sampleBiometrics
    }..removeWhere((key, value) => value == null);
  }
}

class IdentifiedCandidate {
  late Map<String, dynamic> json;

  int? rank;
  String? externalId;
  double? normalizedMatchScore;
  String? rawMatchScore;

  IdentifiedCandidate(this.json) {
    rank = json["rank"];
    externalId = json["subject"]["externalId"];
    normalizedMatchScore = json["normalizedMatchScore"];
    rawMatchScore = json["rawMatchScore"];
  }
}

class IdentifySubjectInGalleryResult {
  late Map<String, dynamic> json;

  List<StatusMessageModel> statusMessages = [];
  List<IdentifiedCandidate> candidate = [];
  int? matchResultId;
  int? matchDuration;

  IdentifySubjectInGalleryResult(this.json) {
    for (var element in json["statusMessages"]) {
      statusMessages.add(StatusMessageModel(element));
    }
    for (var element in json["candidate"]) {
      candidate.add(IdentifiedCandidate(element));
    }

    matchResultId = json["matchResultReference"]["matchResultId"];
    matchDuration = json["matchResultReference"]["matchDuration"];
  }
}