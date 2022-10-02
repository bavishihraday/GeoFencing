import 'package:fairticketsolutions_demo_app/http/venue_server.dart';
import 'package:fairticketsolutions_demo_app/provider/counter.dart';
import 'package:fairticketsolutions_demo_app/provider/profile.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../models/venue_server_models.dart';
import 'dart:math';

class TicketManagement extends StatelessWidget {
  const TicketManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>.value(
      value: counterProvider,
      child: const MyTickets(),
    );
  }
}

class MyTickets extends StatelessWidget {
  const MyTickets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<Counter>(context);
    final TextEditingController cardInfoController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    List<Widget> ticketWidgets = [];

    for (var i = 0; i < counter.value; i++) {
      ticketWidgets.add(
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 50,
            width: 300,
            child: SfBarcodeGenerator(
              value: '${i * 10}',
            ),
          ),
        ),
      );
    }

    return Consumer<Counter>(
      builder: (_, c, __) => Scaffold(
        appBar: AppBar(
          title: const Text("Ticket Management"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: ticketWidgets),
              ),
            ),
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 250,
                      child: TextFormField(
                        controller: cardInfoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: "Enter Card Info",
                            border: OutlineInputBorder()
                        ),
                        enableSuggestions: false,
                        autocorrect: false,
                        validator: (value) {
                          return value == null || value.isEmpty ? "Please enter a valid card number" : null;
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                      ),
                    ),
                    GFButton(
                      size: GFSize.LARGE,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var rng = Random();

                          DialogBuilder.showLoadingDialog(context);

                          try {

                            // Add all tickets concurrently
                            List<Future> futures = [];
                            for (int i = 0; i < counter.value; i++) {
                              futures.add(VenueServer.addTicket(
                                TicketModel(
                                  barcode: (rng.nextInt(99999999)).toString(),
                                  section: "A",
                                  row: i.toString(),
                                  seat: (i + 14).toString(),
                                  holder: profileProvider.getEmail().toString(),
                                  hash: cardInfoController.text,
                                  overridden: false,
                                  eventId: 1,
                                  createdAt: DateTime.now().toString(),
                                  updatedAt: DateTime.now().toString(),
                                ),
                              ));
                            }
                            await Future.wait(futures);

                            DialogBuilder.popDialog(context);

                            final snackBar = SnackBar(
                              content: Text(
                                  '${counter.value} tickets bought Successfully!'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                          catch (e) {
                            DialogBuilder.popDialog(context);

                            DialogBuilder.showInfoDialog(context, "Error", "$e");
                          }
                        }
                      },
                      type: GFButtonType.outline,
                      child: const Text('Buy Now!'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
