// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/screens/ticket_details_screen.dart';
import 'package:ticketmaster/screens/widgets/ticket_successful_modal.dart';

class EventDetails extends StatefulWidget {
  final String artistName;
  final String eventName;
  final String section;
  final String row;
  final String seat;
  final String date;
  final String location;
  final String time;
  final String image;
  final String ticketType;
  final String level;
  final int number_of_ticket;
  const EventDetails(
      {super.key,
      required this.artistName,
      required this.eventName,
      required this.section,
      required this.row,
      required this.seat,
      required this.date,
      required this.location,
      required this.time,
      required this.image,
      required this.ticketType,
      required this.level,
      required this.number_of_ticket});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  int currentIndex = 0;
  List<String> images = [
    'assets/images/event.jpg',
    'assets/images/event.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // _artistName = prefs.getString('artistName') ?? 'N/A';
      // _eventName = prefs.getString('eventName') ?? 'N/A';
      // _section = prefs.getString('section') ?? 'N/A';
      // _row = prefs.getString('row') ?? 'N/A';
      // _seat = prefs.getString('seat') ?? '1';

      // _date = prefs.getString('date') ?? 'N/A';
      // _location = prefs.getString('location') ?? 'N/A';
      // _time = prefs.getString('time') ?? 'N/A';
      // _image = prefs.getString('image') ?? '';
      // _ticketType = prefs.getString('ticketType') ?? 'N/A';
      // _level = prefs.getString('level') ?? 'N/A';
      // number_of_ticket = prefs.getInt('numberOfTicket') ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1f262e),
        leading: Padding(
          padding: const EdgeInsets.all(17.0),
          child: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                "assets/images/cancel.png",
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: const Text(
          "My Tickets",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(right: 10),
                height: 30,
                width: 60,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Help',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.72,
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: widget.number_of_ticket,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.04,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.04,
                                  color: const Color(0xff0361cb),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minHeight: 1, minWidth: 1),
                                          child: Text(
                                            widget.ticketType,
                                            //  maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.1,
                              color: const Color(0xff006ce7),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.09),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "SEC",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          widget.section,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "ROW",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          widget.row,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "SEAT",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          widget.seat == '1'
                                              ? ''
                                              : widget.seat == '-'
                                                  ? widget.seat
                                                  : (int.parse(widget.seat) +
                                                          index)
                                                      .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.25,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    widget.image, // Replace with your image URL
                                  ),
                                ),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black,
                                  ],
                                  stops: [0.0, 1.5],
                                  begin: FractionalOffset.topCenter,
                                  end: FractionalOffset.bottomCenter,
                                )),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.175,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8, top: 8),
                                      child: FittedBox(
                                        child: Text(
                                          widget.artistName +
                                              ' | ' +
                                              widget.eventName,
                                          style: const TextStyle(
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8,
                                        right: 8,
                                      ),
                                      child: FittedBox(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              widget.date +
                                                  " " +
                                                  widget.time +
                                                  " ",
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              height: 5,
                                              width: 5,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.5)),
                                            ),
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Text(
                                              widget.location,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.28,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 10,
                                      left: MediaQuery.of(context).size.width *
                                          0.17,
                                      right: MediaQuery.of(context).size.width *
                                          0.17),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        widget.level,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.53,
                                        decoration: BoxDecoration(
                                            color: const Color(0xff006ce7),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              const FittedBox(
                                                child: Text(
                                                  "View in Wallet",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "View Barcode",
                                            style: TextStyle(
                                                color: Colors.blue.shade800,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const TicketDetails(),
                                                ));
                                              },
                                              child: Text(
                                                "Ticket Details",
                                                style: TextStyle(
                                                    color: Colors.blue.shade800,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.03,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    bottomRight: Radius.circular(8)),
                                color: Color(0xff0361cb),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                              'assets/images/verified.png',
                                            ),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Text(
                                      "ticketmaster.verified",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        // child: Image.asset(
                        //   images[index % images.length],
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < widget.number_of_ticket; i++)
                  buildIndicator(currentIndex == i)
              ]),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheet(
                        context,
                      );
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff0361cb),
                      ),
                      child: const Center(
                          child: Text(
                        "Transfer",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      )),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                    ),
                    child: const Center(
                        child: Text(
                      "Sell",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Column myColumn({text, textt}) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 40),
        ),
        const SizedBox(
          height: 7,
        ),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
          child: Text(
            textt,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.63,
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            // height: MediaQuery.of(context).size.height * 0.62,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                      alignment: Alignment.center,
                      child: Text('TRANSFER TICKET')),
                  const Divider(),
                  const Text("Ticket Selected"),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text("Sec ${widget.section}, "),
                      Text("Row ${widget.row}, "),
                      Text("Seat ${widget.seat} "),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  transferTicketContainer(context,
                      text: "Lizzie", height: 35.0),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Last Name"),
                  const SizedBox(
                    height: 3,
                  ),
                  transferTicketContainer(context,
                      text: "Wilson", height: 35.0),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Email or Mobile Number"),
                  const SizedBox(
                    height: 3,
                  ),
                  transferTicketContainer(context,
                      text: "iamlizziew74@example.com", height: 35.0),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text("Note"),
                  const SizedBox(
                    height: 3,
                  ),
                  Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_left,
                              color: Color(0xff006ce7),
                            ),
                            Text(
                              "BACK",
                              style: TextStyle(
                                color: Color(0xff006ce7),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          AwesomeDialog(
                            context: context,
                            headerAnimationLoop: false,
                            animType: AnimType.BOTTOMSLIDE,
                            dialogType: DialogType.NO_HEADER,
                            body: const TicketTransferSuccessfullModal(),
                          ).show();
                        },
                        child: Container(
                          height: 40,
                          width: 210,
                          decoration: const BoxDecoration(
                            color: Color(0xff006ce7),
                          ),
                          child: const Center(
                              child: Text(
                            "Transfer Ticket",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 400,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildIndicator(bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        height: isSelected ? 8 : 7,
        width: isSelected ? 8 : 7,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Colors.black : Colors.grey),
      ),
    );
  }
}

Container transferTicketContainer(BuildContext context, {height, text}) {
  return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 8,
            top: 16,
          ),
          child: TextField(
            cursorColor: Colors.black,
            decoration: InputDecoration(
                hintText: text,
                // suffixIcon: const Icon(
                //   Icons.cancel,
                //   size: 20,
                // ),
                border: InputBorder.none,
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent))),
          ),
        ),
      ));
}
