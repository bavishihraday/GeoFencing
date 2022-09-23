import 'package:fairticketsolutions_demo_app/http/venue_server.dart';
import 'package:fairticketsolutions_demo_app/models/venue_server_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Tickets with ChangeNotifier {
  List<TicketModel> tickets = [];

  Future<void> getTickets(String email) async {
    List<TicketModel>? holderTickets = await VenueServer.getTicketsForHolder(email);

    if (holderTickets != null) tickets = holderTickets;

    // Get all ticket activation statuses concurrently
    List<Future> futures = [];
    for (TicketModel ticket in tickets) {
      futures.add(VenueServer.isTicketActive(ticket.barcode!).then((isTicketActivated) => ticket.isTicketActive = isTicketActivated));
    }
    await Future.wait(futures);

    notifyListeners();
  }
}

Tickets ticketsProvider = Tickets();