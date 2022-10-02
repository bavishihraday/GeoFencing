import 'package:fairticketsolutions_demo_app/capture_actions/biosp_face_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/capture_actions/biosp_voice_capture_actions.dart';
import 'package:fairticketsolutions_demo_app/http/venue_server.dart';
import 'package:fairticketsolutions_demo_app/models/venue_server_models.dart';
import 'package:fairticketsolutions_demo_app/utils/dialog_builder.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:getwidget/getwidget.dart';

class TicketActivation extends StatelessWidget {
  final TicketModel ticket;
  const TicketActivation({Key? key, required this.ticket}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardInfoController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipPath(
              clipper: DolDurmaClipper(right: 60, holeRadius: 30),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  color: Color(0xFFc1c1c1),
                ),
                width: 350,
                height: 230,
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ticket Id: ${ticket.barcode}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Ticket Status: ${ticket.isTicketActive}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 75,
                            width: 300,
                            child: SfBarcodeGenerator(
                              value: ticket.barcode,
                              showValue: true,
                              textStyle: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Row: ${ticket.row}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Seat No.: ${ticket.seat}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (ticket.isTicketActive != 0) ...[
                    GFButton(
                      size: GFSize.LARGE,
                      onPressed: () async {
                        bool faceVerified = (await BiospFaceCaptureActions.verifyFace(context, "Verify Face")) > 10.0;

                        if (faceVerified) {
                          ticket.isTicketActive = 0;
                          const snackBar = SnackBar(
                            content: Text('Tickets Activated Successfully!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          Navigator.pop(context, true);
                        }
                        else {
                          const snackBar = SnackBar(
                            content: Text('Face Not Matched, Please Retry!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      type: GFButtonType.outline,
                      child: const Text('Face Match'),
                    ),
                    GFButton(
                      size: GFSize.LARGE,
                      onPressed: () async {
                        bool voiceVerified = await VoiceCaptureActions.verifyVoice(context, 10.0, "Verify Voice", false);

                        if (voiceVerified) {
                          ticket.isTicketActive = 0;
                          const snackBar = SnackBar(
                            content: Text('Tickets Activated Successfully!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          Navigator.pop(context, true);
                        }
                        else {
                          const snackBar = SnackBar(
                            content: Text('Voice not matched, Please Retry!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      type: GFButtonType.outline,
                      child: const Text('Voice Match'),
                    ),
                  ] else ...[
                    Column(
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
                          child: const Text(
                            'Check in Now!',
                          ),
                        ),
                      ],
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DolDurmaClipper extends CustomClipper<Path> {
  DolDurmaClipper({required this.right, required this.holeRadius});

  final double right;
  final double holeRadius;

  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width - right - holeRadius, 0.0)
      ..arcToPoint(
        Offset(size.width - right, 0),
        clockwise: false,
        radius: const Radius.circular(1),
      )
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - right, size.height)
      ..arcToPoint(
        Offset(size.width - right - holeRadius, size.height),
        clockwise: false,
        radius: const Radius.circular(1),
      );

    path.lineTo(0.0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(DolDurmaClipper oldClipper) => true;
}
