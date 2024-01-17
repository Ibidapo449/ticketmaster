import 'package:flutter/material.dart';

class TicketDetails extends StatelessWidget {
  const TicketDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(Icons.ac_unit),
        title: const Padding(
          padding: EdgeInsets.only(left: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ticket Details",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                "Help",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myColumn(text: "Seat Location", textt: "LAWN30 / GA3 / -"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(
                  text: "Fall Out Boy - So Much For (Tour) Dust",
                  textt: "Tue, Jul 18, 6:30pm. Blossom Music Center"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(text: "Entry Info", textt: "ALLENGIANT LAWN"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ticket Info",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ticketInfoText(text: "LIVE NATION PRESENTS"),
                  ticketInfoText(text: "FALL OUT BOY"),
                  ticketInfoText(text: "SO MUCH FOR (TOUR) DUST"),
                  ticketInfoText(text: "BLOSSOM MUSIC CAREER"),
                  ticketInfoText(text: "RAIN OR SHINE EVENT"),
                  ticketInfoText(text: "TUE JUL 18 2023 6:30 PM"),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(
                  text: "Blossom Music Center", textt: "Cuyahoga Falls OH US"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(text: "Order Number", textt: "55036484"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(text: "Ticket Type", textt: "Seated Ticket - Side view"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(
                  text: "Purchase Date", textt: "Sun, Jan 15 2023 - 10:51a.m"),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ticket Price",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  myRow(
                      text: "Take A Seat Bundle (lawn Ticket + Lawn Chair)",
                      textt: "\$54.50"),
                  const SizedBox(
                    height: 3,
                  ),
                  myRow(text: "Fee", textt: "\$16.35"),
                  const SizedBox(
                    height: 3,
                  ),
                  myRow(text: "Tax", textt: "\$1.64"),
                  const SizedBox(
                    height: 3,
                  ),
                  myRow(text: "GRAND TOTAL", textt: "\$72.49"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Text ticketInfoText({text}) => Text(
        text,
        style: const TextStyle(color: Colors.grey),
      );

  Row myRow({text, textt}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          textt,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Column myColumn({text, textt}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          textt,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
