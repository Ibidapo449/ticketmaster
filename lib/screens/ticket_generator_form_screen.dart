import 'package:flutter/material.dart';

class TicketGeneratorForm extends StatefulWidget {
  const TicketGeneratorForm({super.key});

  @override
  State<TicketGeneratorForm> createState() => _TicketGeneratorFormState();
}

class _TicketGeneratorFormState extends State<TicketGeneratorForm> {
  final TextEditingController _artistNameEditingController = TextEditingController();
  final TextEditingController _eventTitleEditingController = TextEditingController();
  final TextEditingController _ticketTypeEditingController = TextEditingController();
  final TextEditingController _venueEditingController = TextEditingController();
  final TextEditingController _locationEditingController = TextEditingController();
  final TextEditingController _sectionEditingController = TextEditingController();
  final TextEditingController _seatEditingController = TextEditingController();
  final TextEditingController _rowEditingController = TextEditingController();
  final TextEditingController _dateEditingController = TextEditingController();
  final TextEditingController _timeEditingController = TextEditingController();
  final TextEditingController _levelEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ticket Generator Form",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(
              height: 10,
            ),
            const Wrap(children: [
              Text(
                'Please fill the form for each ticket item and make sure to click on "Add ticket" to add each ticket item to cart before proceding to click "Generate tickets"',
                style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              )
            ]),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formColumn(context,
                    text: "Artist Name",
                    hintText: "Taylor Swift",
                    controller: _artistNameEditingController,
                    keyboardType: TextInputType.text),
                formColumn(context,
                    text: "Event Title",
                    hintText: "The Eras Tour",
                    controller: _eventTitleEditingController,
                    keyboardType: TextInputType.text),
                const SizedBox(
                  width: 40,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formColumn(context,
                    text: "Ticket Type",
                    hintText: "Taylor Swift",
                    controller: _ticketTypeEditingController,
                    keyboardType: TextInputType.text),
                formColumn(context,
                    text: "Venue",
                    hintText: "Enter Venue",
                    controller: _venueEditingController,
                    keyboardType: TextInputType.text),
                const SizedBox(
                  width: 40,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formColumn(context,
                    text: "Location",
                    hintText: "Enter Location",
                    controller: _locationEditingController,
                    keyboardType: TextInputType.text),
                formColumn(context,
                    text: "Section",
                    hintText: "GA",
                    controller: _sectionEditingController,
                    keyboardType: TextInputType.text),
                const SizedBox(
                  width: 40,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formColumn(context,
                    text: "Row",
                    hintText: "71",
                    controller: _rowEditingController,
                    keyboardType: TextInputType.number),
                formColumn(context,
                    text: "Seat",
                    hintText: "54",
                    controller: _seatEditingController,
                    keyboardType: TextInputType.number),
                const SizedBox(
                  width: 40,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formColumn(context,
                    text: "Date",
                    hintText: "dd-mm-yyyy",
                    controller: _dateEditingController,
                    keyboardType: TextInputType.text),
                formColumn(context,
                    text: "Time",
                    hintText: "hh-mm am/pm",
                    controller: _timeEditingController,
                    keyboardType: TextInputType.text),
                const SizedBox(
                  width: 40,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formColumn(context,
                    text: "level",
                    hintText: "optional",
                    controller: _levelEditingController,
                    keyboardType: TextInputType.text),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                formColumn(context,
                    text: "Event Title(Filter Search)",
                    hintText: "optional",
                    controller: _eventTitleEditingController,
                    keyboardType: TextInputType.text),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column formColumn(BuildContext context,
      {text, hintText, controller, keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
              ),
              controller: controller,
              keyboardType: keyboardType,
            ),
          ),
        )
      ],
    );
  }
}
