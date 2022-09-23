import 'dart:convert';
import 'dart:io';

import 'package:fairticketsolutions_demo_app/constants/http_base_urls.dart';
import 'package:fairticketsolutions_demo_app/models/venue_server_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VenueServer {
  static String serverBaseString = kVenueServerBaseUrl;
  static Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json",
    "x-rest-api-key": "79b5ed20827b6511990eff51ffec52797ba5abd8"
  };

  static Future<List<TicketModel>?> getAllTickets() async {
    Uri uri = Uri.parse("$serverBaseString/api/Tickets");
    http.Response response;

    try {
      response = await http.get(
        uri,
        headers: requestHeaders
      );

      debugPrint("~~GET ALL TICKETS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      List<dynamic> responseJson = jsonDecode(response.body);

      List<TicketModel>? responseList;

      if (response.statusCode == 200) {
        responseList = responseJson.map((dynamic ticket) => TicketModel(json: ticket)).toList();
      }

      return responseList;
    } on HttpException catch (e) {
      debugPrint("~~GET ALL TICKETS~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<List<TicketModel>?> getTicketsForHolder(String holder) async {
    Uri uri = Uri.parse("$serverBaseString/api/Tickets?filter[where][holder]=$holder");
    http.Response response;

    try {
      response = await http.get(
          uri,
          headers: requestHeaders
      );

      debugPrint("~~GET TICKETS FOR HOLDER $holder~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      List<dynamic> responseJson = jsonDecode(response.body);

      List<TicketModel>? responseList;

      if (response.statusCode == 200) {
        responseList = responseJson.map((dynamic ticket) => TicketModel(json: ticket)).toList();
      }

      return responseList;
    } on HttpException catch (e) {
      debugPrint("~~GET TICKETS FOR HOLDER $holder~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<TicketModel?> addTicket(TicketModel ticket) async {
    Uri uri = Uri.parse("$serverBaseString/api/Tickets");
    http.Response response;

    try {
      response = await http.post(
        uri,
        headers: requestHeaders,
        body: jsonEncode(ticket.toEncodable())
      );

      debugPrint("~~ADD TICKET FOR HOLDER ${ticket.holder}~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? TicketModel(json: jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~ADD TICKET FOR HOLDER ${ticket.holder}~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<CheckInResult?> checkIn(String hash) async {
    Uri uri = Uri.parse("$serverBaseString/api/CheckIns/checkIn");
    http.Response response;

    try {
      response = await http.put(
        uri,
        headers: requestHeaders,
        body: jsonEncode(CheckInRequest(hash: hash).toEncodable())
      );

      debugPrint("~~CHECK IN FOR HASH $hash~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? CheckInResult(json: jsonDecode(response.body)) : null;
    } on HttpException catch (e) {
      debugPrint("~~CHECK IN FOR HASH $hash~~\nHttp Error: $e");

      return null;
    }
  }

  static Future<void> clearAllCheckIns() async {
    Uri uri = Uri.parse("$serverBaseString/api/CheckIns/clear");
    http.Response response;

    try {
      response = await http.put(
        uri,
        headers: requestHeaders
      );

      debugPrint("~~CLEAR ALL CHECK INS~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");
    } on HttpException catch (e) {
      debugPrint("~~CLEAR ALL CHECK INS~~\nHttp Error: $e");
    }
  }

  // 0 == yes, 1 == barCodeNotFound, 2 == no, 3 == activationTimedOut, 4 == noCurrentEvent
  static Future<int?> isTicketActive(String barcode) async {
    Uri uri = Uri.parse("$serverBaseString/api/Tickets/isActive");
    http.Response response;

    try {
      response = await http.put(
        uri,
        headers: requestHeaders,
        body: jsonEncode({ "barcode": barcode })
      );

      debugPrint("~~IS TICKET ACTIVE FOR BARCODE $barcode~~\nHttp Response Code: ${response.statusCode}\nHttp Response Body: ${response.body}");

      return response.statusCode == 200 ? jsonDecode(response.body)!["result"] : null;
    } on HttpException catch (e) {
      debugPrint("~~IS TICKET ACTIVE FOR BARCODE $barcode~~\nHttp Error: $e");

      return null;
    }
  }
}