import 'package:fairticketsolutions_demo_app/http/venue_server.dart';
import 'package:fairticketsolutions_demo_app/models/venue_server_models.dart';
import 'package:fairticketsolutions_demo_app/provider/tickets.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:provider/provider.dart';
import '../provider/profile.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'activate_ticket_screen.dart';

class TicketList extends StatelessWidget {
  const TicketList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ticketsProvider.getTickets(profileProvider.getEmail() ?? "");

    return ChangeNotifierProvider<Tickets>.value(
      value: ticketsProvider,
      child: const MyTickets(),
    );
  }
}

class MyTickets extends StatelessWidget {
  const MyTickets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tickets = Provider.of<Tickets>(context);
    final TextEditingController cardInfoController = TextEditingController();

    List<Widget> ticketWidgets = [];

    for (TicketModel ticket in tickets.tickets) {
      Padding ticketStatus;

      if (ticket.isTicketActive == 0) {
        ticketStatus = Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.width * 0.05,
            child: const Icon(
              IconData(0xe15a, fontFamily: 'MaterialIcons'),
              color: Colors.green,
            ),
          ),
        );
      }
      else {
        ticketStatus = Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
            width: MediaQuery.of(context).size.width * 0.05,
            child: const Icon(
              IconData(0xef28, fontFamily: 'MaterialIcons'),
              color: Colors.red,
            ),
          ),
        );
      }

      ticketWidgets.add(
        GestureDetector(
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TicketActivation(ticket: ticket),
              ),
            ),
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.70,
                  child: SfBarcodeGenerator(
                    value: ticket.barcode,
                  ),
                ),
              ),
              ticketStatus,
            ],
          ),
        ),
      );
    }

    return Consumer<Tickets>(
      builder: (_, c, __) => Scaffold(
        appBar: AppBar(
          title: const Text("My Tickets"),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: const Center(child: Text('Ticket'))),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Center(child: Text('Activated')),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: ticketWidgets,
                  )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 250,
                  child: TextField(
                    controller: cardInfoController,
                    decoration: const InputDecoration(
                        labelText: "Enter Card Info"),
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
                GFButton(
                  size: GFSize.LARGE,
                  onPressed: () async {
                    debugPrint('CheckIn Verification Triggered');

                    DialogBuilder.showLoadingDialog(context);

                    CheckInResult? result = await VenueServer.checkIn(cardInfoController.text);

                    DialogBuilder.popDialog(context);

                    late SnackBar snackBar;

                    if (result != null) {
                      if (result.result == 0) {
                        snackBar = SnackBar(content: Text('${result.ticketCount} tickets checked in successfully!'));
                      }
                      else if (result.result == 1) {
                        snackBar = const SnackBar(content: Text('All tickets already checked in!'));
                      }
                    }
                    else {
                      snackBar = const SnackBar(content: Text('Something went wrong with check in!'));
                    }

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  type: GFButtonType.outline,
                  child: const Text('Check in Now!'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
