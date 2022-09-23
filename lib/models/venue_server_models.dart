class TicketModel {
  String? barcode;
  String? section;
  String? row;
  String? seat;
  String? holder;
  String? hash;
  bool? overridden;
  String? fulfilled;
  int? id;
  int? eventId;
  String? createdAt;
  String? updatedAt;
  int? isTicketActive;

  Map<String, dynamic>? json;

  TicketModel({
    this.barcode,
    this.section,
    this.row,
    this.seat,
    this.holder,
    this.hash,
    this.overridden,
    this.fulfilled,
    this.id,
    this.eventId,
    this.createdAt,
    this.updatedAt,
    this.json
  }) {
    if (json != null) {
      barcode = json!["barcode"];
      section = json!["section"];
      row = json!["row"];
      seat = json!["seat"];
      holder = json!["holder"];
      hash = json!["hash"];
      overridden = json!["overridden"];
      fulfilled = json!["fulfilled"];
      id = json!["id"];
      eventId = json!["eventId"];
      createdAt = json!["createdAt"];
      updatedAt = json!["updatedAt"];
    }
  }

  Map<String, dynamic> toEncodable() {
    return {
      "barcode": barcode,
      "section": section,
      "row": row,
      "seat": seat,
      "holder": holder,
      "hash": hash,
      "overridden": overridden,
      "fulfilled": fulfilled,
      "id": id,
      "eventId": eventId,
      "createdAt": createdAt,
      "updatedAt": updatedAt
    }..removeWhere((key, value) => value == null); // Since some types are nullable, remove them to not cause problems
  }
}

class CheckInRequest {
  final String device = "DEVICE_MOBILE";
  final String method = "METHOD_GEOFENCE";

  late String hash;

  CheckInRequest({required this.hash});

  // Converts to something jsonEncode() can work with
  Map<String, dynamic> toEncodable() {
    return {
      "device": device,
      "method": method,
      "hash": hash
    };
  }
}

class CheckInResult {
  late Map<String, dynamic> json;

  int? result; // 0 means successful, 1 means the tickets are already activated
  int? ticketCount;
  String? holder;

  CheckInResult({required this.json}) {
    result = json["result"];
    ticketCount = json["ticketCount"];
    holder = json["holder"];
  }
}