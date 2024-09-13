// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, library_private_types_in_public_api

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/screens/ticket_details_screen.dart';
import 'package:ticketmaster/screens/widgets/ticket_pending_modal.dart';
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
  int visibleContainerIndex = 0;

  void switchContainer() {
    setState(() {
      visibleContainerIndex = (visibleContainerIndex + 1) % 5;
    });
  }

  final PageController _pageController = PageController(
    viewportFraction: 0.9, // Adjust the fraction as needed
  );

  String _numberOfTicketSelected = '1 Ticket Selected';
  String _seat = '15, 16, 17, 18';

  bool _isEditingNumberOfTicketSelected = false;
  bool _isEditingSeat = false;

  final TextEditingController _numberOfTicketSelectedEditingController =
      TextEditingController();
  final TextEditingController _seatEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedText();
  }

  _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _numberOfTicketSelected =
          prefs.getString('numberof_ticketselected') ?? _numberOfTicketSelected;
      _seat = prefs.getString('seat') ?? _seat;
    });
  }

  _saveText(String newText, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, newText);
  }

  int currentIndex = 0;
  List<String> images = [
    'assets/images/event.jpg',
    'assets/images/event.jpg',
  ];

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
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
                    style: TextStyle(color: Colors.white, fontSize: 17),
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
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.66,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemCount: widget.number_of_ticket,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                color: const Color(0xff006ce7),
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
                                      MediaQuery.of(context).size.width * 0.03),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Stack(
                                        children: [
                                          const Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              "SEC",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: FittedBox(
                                                child: Text(
                                                  widget.section,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Stack(
                                        children: [
                                          const Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              "ROW",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Text(
                                                widget.row,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Stack(
                                        children: [
                                          const Align(
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              "SEAT",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Text(
                                                widget.seat == '1'
                                                    ? ''
                                                    : widget.seat == '-'
                                                        ? widget.seat
                                                        : (int.parse(widget
                                                                    .seat) +
                                                                index)
                                                            .toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.26,
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
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(.98),
                                ],
                                stops: [0.0, 1],
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                              )),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 8,
                                      ),
                                      child: Text(
                                        widget.eventName == ''
                                            ? widget.artistName
                                            : widget.artistName +
                                                ' | ' +
                                                widget.eventName,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
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
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.23,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                ),
                                child: Column(
                                  children: [
                                    // Text(
                                    //   widget.level,
                                    //   style: const TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    GestureDetector(
                                      onTap: () {
                                        switchContainer();
                                      },
                                      child: Stack(children: [
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: visibleContainerIndex == 4
                                              ? 1.0
                                              : 0.0,
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.level,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                          child: Container(
                                                        height: 25,
                                                        width: 40,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          image:
                                                              const DecorationImage(
                                                                  image:
                                                                      AssetImage(
                                                                    'assets/images/applewallet.png',
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover),
                                                        ),
                                                      )),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      const FittedBox(
                                                        child: Text(
                                                          "Add to Apple Wallet",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 35),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "View Barcode",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 51, 90, 135),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                const TicketDetails(),
                                                          ));
                                                        },
                                                        child: const Text(
                                                          "Ticket Details",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      51,
                                                                      90,
                                                                      135),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: visibleContainerIndex == 1
                                              ? 1.0
                                              : 0.0,
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.level,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff006ce7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Center(
                                                          child: Container(
                                                              height: 26,
                                                              width: 26,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13)),
                                                              child: const Icon(
                                                                Icons.check,
                                                                size: 13,
                                                                color: Colors
                                                                    .white,
                                                              ))),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      const FittedBox(
                                                        child: Text(
                                                          "View in wallet",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 35),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "View Barcode",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 51, 90, 135),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                const TicketDetails(),
                                                          ));
                                                        },
                                                        child: const Text(
                                                          "Ticket Details",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      51,
                                                                      90,
                                                                      135),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: visibleContainerIndex == 2
                                              ? 1.0
                                              : 0.0,
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.level,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff006ce7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height: 17,
                                                            width: 30,
                                                            decoration:
                                                                const BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                'assets/images/smarticon.png',
                                                                // height: 30,
                                                                // width: 40,
                                                                // color: const Color
                                                                //     .fromARGB(
                                                                //     255,
                                                                //     236,
                                                                //     236,
                                                                //     236)
                                                                // )
                                                              )),
                                                              // child: SvgPicture.asset(
                                                              //     'assets/images/smarticon.png',
                                                              //     height: 30,
                                                              //     width: 40,
                                                              //     color: const Color
                                                              //         .fromARGB(
                                                              //         255,
                                                              //         236,
                                                              //         236,
                                                              //         236)
                                                              //         ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      const FittedBox(
                                                        child: Text(
                                                          "View Barcode",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      236,
                                                                      236,
                                                                      236)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TicketDetails(),
                                                        ));
                                                      },
                                                      child: const Text(
                                                        "Ticket Details",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    51,
                                                                    90,
                                                                    135),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: visibleContainerIndex == 3
                                              ? 1.0
                                              : 0.0,
                                          child: Column(
                                            children: [
                                              Container(
                                                // color: Colors.red,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                        height: 25,
                                                        width: 25,
                                                        child: Image.asset(
                                                          "assets/images/verified.png",
                                                          color: Colors.black,
                                                        )),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                      "Your tickets aren't quite ready yet.",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const Text(
                                                      "Please check back later",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 50,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   height: 30,
                                              // ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 35),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      "View Barcode",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 51, 90, 135),
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const Spacer(),
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                const TicketDetails(),
                                                          ));
                                                        },
                                                        child: const Text(
                                                          "Ticket Details",
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      51,
                                                                      90,
                                                                      135),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedOpacity(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          opacity: visibleContainerIndex == 0
                                              ? 1.0
                                              : 0.0,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                widget.level,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Container(
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75,
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xff006ce7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1)),
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Container(
                                                            height: 17,
                                                            width: 30,
                                                            decoration:
                                                                const BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                'assets/images/smarticon.png',
                                                              )),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 8,
                                                      ),
                                                      const FittedBox(
                                                        child: Text(
                                                          "View Ticket",
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      236,
                                                                      236,
                                                                      236)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                              ),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TicketDetails(),
                                                        ));
                                                      },
                                                      child: const Text(
                                                        "Ticket Details",
                                                        style: TextStyle(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                51, 90, 135),
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(8),
                                  bottomRight: Radius.circular(8)),
                              color: Color(0xff0361cb),
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
              height: 20,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var i = 0; i < widget.number_of_ticket; i++)
                buildIndicator(currentIndex == i)
            ]),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.of(context).pop();
                    _showBottomSheet1(
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
                    color: const Color(0xff0361cb),
                  ),
                  child: const Center(
                      child: Text(
                    "Sell",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  )),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                color: Colors.red,
              ),
            )
          ],
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

  void _showBottomSheet1(
    BuildContext context,
  ) {
    List<bool> _checkboxStates =
        List<bool>.filled(widget.number_of_ticket, false);

    // Function to count the number of checked checkboxes
    int _countChecked() {
      return _checkboxStates.where((isChecked) => isChecked).length;
    }

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setstate1) {
          return FractionallySizedBox(
            heightFactor: 0.63,
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(color: Colors.white),
                // height: MediaQuery.of(context).size.height * 0.62,
                child: Column(
                  // shrinkWrap: true,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: Text('SELECT TICKETS TRANSFER TICKET')),
                    Divider(
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey.shade200,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Sec ",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '${widget.section},',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    " Row ",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontSize: 16),
                                  ),
                                  Text(
                                    widget.row,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "${widget.number_of_ticket.toString()} Tickets",
                            style: TextStyle(
                              color: Colors.black.withOpacity(.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 15),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 82,
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.number_of_ticket,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10))),
                                      height: 82,
                                      width: 80,
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: const BoxDecoration(
                                                color: Color(0xff0361cb),
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(9),
                                                )),
                                            height: 30,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "SEAT ",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                      widget.seat == '1'
                                                          ? ''
                                                          : widget.seat == '-'
                                                              ? widget.seat
                                                              : (int.parse(widget
                                                                          .seat) +
                                                                      index)
                                                                  .toString(),
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Colors.transparent,
                                            height: 50,
                                            child: Center(
                                              child: CustomCircleCheckbox(
                                                isChecked:
                                                    _checkboxStates[index],
                                                onChanged: (bool? value) {
                                                  setstate1(() {
                                                    _checkboxStates[index] =
                                                        value ?? false;
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey.shade300,
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_countChecked()} Selected",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(.7),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    _showBottomSheet2(
                                      context,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "TRAN...ER TO",
                                        style: TextStyle(
                                          color: const Color(0xff0361cb)
                                              .withOpacity(.8),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.grey,
                                        size: 25,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 35,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _showBottomSheet2(
    BuildContext context,
  ) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setstate1) {
          bool _isDoubleTap = false;
          return FractionallySizedBox(
            heightFactor: 0.63,
            child: Scaffold(
              body: Container(
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
                      GestureDetector(
                        onTap: () {
                          setstate1(() {
                            _isEditingNumberOfTicketSelected = true;
                            _numberOfTicketSelectedEditingController.text =
                                _numberOfTicketSelected;
                          });
                          setState(() {
                            _isEditingNumberOfTicketSelected = true;
                            _numberOfTicketSelectedEditingController.text =
                                _numberOfTicketSelected;
                          });
                        },
                        child: _isEditingNumberOfTicketSelected
                            ? TextField(
                                controller:
                                    _numberOfTicketSelectedEditingController,
                                style: const TextStyle(color: Colors.grey),
                                onSubmitted: (newText) {
                                  if (newText.isNotEmpty) {
                                    _saveText(
                                        newText, 'numberof_ticketselected');
                                    setstate1(() {
                                      _numberOfTicketSelected = newText;
                                      _isEditingNumberOfTicketSelected = false;
                                    });
                                    setState(() {
                                      _numberOfTicketSelected = newText;
                                      _isEditingNumberOfTicketSelected = false;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Ticket Price cannot be empty'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              )
                            : Text(
                                _numberOfTicketSelected,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      // const Text("1 Ticket Selected"),
                      // widget.number_of_ticket == 1
                      //     ? Text(
                      //         "${widget.number_of_ticket.toString()} Ticket Selected")
                      //     : Text(
                      //         "${widget.number_of_ticket.toString()} Tickets Selected"),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Sec ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.4)),
                              ),
                              Text(
                                '${widget.section} ,',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Row ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.4)),
                              ),
                              Text(
                                '${widget.row} ,',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Seat ",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(.4)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setstate1(() {
                                    _isEditingSeat = true;
                                    _seatEditingController.text = _seat;
                                  });
                                  setState(() {
                                    _isEditingSeat = true;
                                    _seatEditingController.text = _seat;
                                  });
                                },
                                child: _isEditingSeat
                                    ? Container(
                                        color: Colors.transparent,
                                        width: 180,
                                        child: TextField(
                                          controller: _seatEditingController,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                          onSubmitted: (newText) {
                                            if (newText.isNotEmpty) {
                                              _saveText(newText, 'seat');
                                              setstate1(() {
                                                _seat = newText;
                                                _isEditingSeat = false;
                                              });
                                              setState(() {
                                                _seat = newText;
                                                _isEditingSeat = false;
                                              });
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Seat cannot be empty'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    : Text(
                                        _seat,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                              ),

                              //  Text(
                              //   widget.seat,
                              //   style: const TextStyle(fontWeight: FontWeight.bold),
                              // )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("First Name"),
                      transferTicketContainer(context,
                          text: "First Name", height: 40.0),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("Last Name"),
                      const SizedBox(
                        height: 3,
                      ),
                      transferTicketContainer(context,
                          text: "Last Name", height: 40.0),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("Email or Mobile Number"),
                      const SizedBox(
                        height: 3,
                      ),
                      transferTicketContainer(context,
                          text: "Email or Mobile Number", height: 40.0),
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
                                      borderSide: BorderSide(
                                          color: Colors.transparent))),
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
                              Timer(Duration(milliseconds: 300), () {
                                if (!_isDoubleTap) {
                                  Navigator.of(context).pop();
                                  AwesomeDialog(
                                    context: context,
                                    headerAnimationLoop: false,
                                    animType: AnimType.bottomSlide,
                                    dialogType: DialogType.noHeader,
                                    body:
                                        const TicketTransferSuccessfullModal(),
                                  ).show();
                                }
                              });
                            },
                            onDoubleTap: () {
                              _isDoubleTap = true;
                              Navigator.of(context).pop();
                              AwesomeDialog(
                                context: context,
                                headerAnimationLoop: false,
                                animType: AnimType.bottomSlide,
                                dialogType: DialogType.noHeader,
                                body: const TicketTransferPendinglModal(),
                              ).show();
                              Future.delayed(Duration(milliseconds: 300), () {
                                _isDoubleTap =
                                    false; // Reset the flag after the delay
                              });
                            },
                            child: Container(
                              height: 40,
                              width: 210,
                              decoration: const BoxDecoration(
                                color: Color(0xff006ce7),
                              ),
                              child: Center(
                                  child: Text(
                                widget.number_of_ticket == 1
                                    ? "Transfer Ticket"
                                    : "Transfer Tickets",
                                style: const TextStyle(color: Colors.white),
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
            ),
          );
        });
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
                hintStyle: TextStyle(color: Colors.black.withOpacity(.3)),
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

class CustomCircleCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const CustomCircleCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  _CustomCircleCheckboxState createState() => _CustomCircleCheckboxState();
}

class _CustomCircleCheckboxState extends State<CustomCircleCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant CustomCircleCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isChecked != widget.isChecked) {
      setState(() {
        _isChecked = widget.isChecked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChanged(_isChecked);
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isChecked ? const Color(0xff0361cb) : Colors.white,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: _isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
