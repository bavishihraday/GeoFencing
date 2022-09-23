import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fairticketsolutions_demo_app/models/aws_face_models.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../constants/http_base_urls.dart';

class AwsFace {
  static String serverBaseString = kAwsFaceBaseUrl;

  static Future<String> registerFace(String fileName, Uint8List? imageBlob) async {
    Uri uri = Uri.parse("$serverBaseString/beta/register_face");
    http.Response response;

    try {
      response = await http.put(
          uri,
          body: jsonEncode({
            "file_name": fileName,
            "base_64_img": imageBlob != null ? base64Encode(imageBlob.toList()) : ""
          })
      );

      debugPrint("~~REGISTER FACE START~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}\n~~REGISTER FACE END~~");

      if (response.statusCode == 200) {
        return response.body;
      }
      else {
        throw Exception("Error ${response.statusCode}:\n${response.body}");
      }
    } on HttpException catch (e) {
      debugPrint("~~REGISTER FACE START~~\nHttp Error: $e\n~~REGISTER FACE END~~");

      rethrow;
    }
  }

  static Future<String> addCollection(String collectionId) async {
    Uri uri = Uri.parse("$serverBaseString/beta/add_collection");
    http.Response response;

    try {
      response = await http.put(
          uri,
          body: jsonEncode({ "collection_id": collectionId })
      );

      debugPrint("~~ADD COLLECTION START~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}\n~~ADD COLLECTION END~~");

      if (response.statusCode == 200) {
        return response.body;
      }
      else {
        throw Exception("Error ${response.statusCode}:\n${response.body}");
      }
    } on HttpException catch (e) {
      debugPrint("~~ADD COLLECTION START~~\nHttp Error: $e\n~~ADD COLLECTION END~~");

      rethrow;
    }
  }

  static Future<String> moveToCollection(String fileName, String collectionId) async {
    Uri uri = Uri.parse("$serverBaseString/beta/move_to_collection");
    http.Response response;

    try {
      response = await http.post(
          uri,
          body: jsonEncode({ "file_name": fileName, "collection_id": collectionId })
      );

      debugPrint("~~MOVE TO COLLECTION START~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}\n~~MOVE TO COLLECTION END~~");

      if (response.statusCode == 200) {
        return response.body;
      }
      else {
        throw Exception("Error ${response.statusCode}:\n${response.body}");
      }
    } on HttpException catch (e) {
      debugPrint("~~MOVE TO COLLECTION START~~\nHttp Error: $e\n~~MOVE TO COLLECTION END~~");

      rethrow;
    }
  }

  static Future<List<String>> getAllCollections(String fileName, String collectionId) async {
    Uri uri = Uri.parse("$serverBaseString/beta/get-all-collections");
    http.Response response;

    try {
      response = await http.get(
          uri
      );

      debugPrint("~~GET ALL COLLECTIONS START~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}\n~~GET ALL COLLECTIONS END~~");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
        throw Exception("Error ${response.statusCode}:\n${response.body}");
      }
    } on HttpException catch (e) {
      debugPrint("~~GET ALL COLLECTIONS START~~\nHttp Error: $e\n~~GET ALL COLLECTIONS END~~");

      rethrow;
    }
  }

  static Future<FaceActionResult> matchFace(String sourceImageFileName, Uint8List? targetImageBlob, int threshold) async {
    Uri uri = Uri.parse("$serverBaseString/beta/match_face");
    http.Response response;

    try {
      response = await http.post(
          uri,
          body: jsonEncode({
            "source_image_file_name": sourceImageFileName,
            "base_64_target_img":  targetImageBlob != null ? base64Encode(targetImageBlob.toList()) : "",
            "threshold": threshold
          })
      );

      debugPrint("~~MATCH FACE START~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}\n~~MATCH FACE END~~");

      if (response.statusCode == 200) {
        return FaceActionResult(jsonDecode(response.body));
      }
      else if (response.statusCode == 500) {
        throw Exception("Face was not found!"); // Server responds with error 500 if face is not found in the provided image
      }
      else {
        throw Exception("Error ${response.statusCode}:\n${response.body}");
      }
    } on HttpException catch (e) {
      debugPrint("~~MATCH FACE START~~\nHttp Error: $e\n~~MATCH FACE END~~");

      rethrow;
    }
  }

  static Future<FaceActionResult> findFace(String collectionId, Uint8List? targetImageBlob, int threshold) async {
    Uri uri = Uri.parse("$serverBaseString/beta/find_face");
    http.Response response;

    try {
      response = await http.post(
          uri,
          body: jsonEncode({
            "collection_id": collectionId,
            "base_64_img":  targetImageBlob != null ? base64Encode(targetImageBlob.toList()) : "",
            "threshold": threshold
          })
      );

      debugPrint("~~FIND FACE START~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}\n~~FIND FACE END~~");

      if (response.statusCode == 200) {
        return FaceActionResult(jsonDecode(response.body));
      }
      else if (response.statusCode == 500) {
        throw Exception("Face was not found!"); // Server responds with error 500 if face is not found in the provided image
      }
      else {
        throw Exception("Error ${response.statusCode}:\n${response.body}");
      }
    } on HttpException catch (e) {
      debugPrint("~~FIND FACE START~~\nHttp Error: $e\n~~FIND FACE END~~");

      rethrow;
    }
  }

  static Future<String> deleteImage(String fileName) async {
    Uri uri = Uri.parse("$serverBaseString/beta/delete-image");
    http.Response response;

    try {
      response = await http.delete(
          uri,
          body: jsonEncode({ "file_name": fileName })
      );

      debugPrint("~~DELETE IMAGE START~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}\n~~DELETE IMAGE END~~");

      if (response.statusCode == 200) {
        return response.body;
      }
      else {
        throw Exception("Error ${response.statusCode}:\n${response.body}");
      }
    } on HttpException catch (e) {
      debugPrint("~~DELETE IMAGE START~~\nHttp Error: $e\n~~DELETE IMAGE END~~");

      rethrow;
    }
  }
}