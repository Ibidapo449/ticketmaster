// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings

import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/event_detaila_screen_with_tabbar.dart';
import 'package:ticketmaster/screens/event_details_screen.dart';
import 'package:ticketmaster/screens/form_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../../providers/colorProvider.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  void initState() {
    super.initState();
    gettoken();
    loadDaysValue();
    loadEventTextState();
  }

  int token = 0;
  int daysUntilEvent = 2; // Default value
  bool showNextEvent =
      true; // true for "Next Event:", false for "Enjoy your event"

  void gettoken() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getInt('token') ?? 0;
    });
  }

  void loadDaysValue() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      daysUntilEvent = pref.getInt('daysUntilEvent') ?? 2;
    });
  }

  void loadEventTextState() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      showNextEvent = pref.getBool('showNextEvent') ?? true;
    });
  }

  void saveEventTextState(bool state) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('showNextEvent', state);
    setState(() {
      showNextEvent = state;
    });
  }

  void toggleEventText() {
    saveEventTextState(!showNextEvent);
  }

  void saveDaysValue(int days) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt('daysUntilEvent', days);
    setState(() {
      daysUntilEvent = days;
    });
  }

  void showEditDaysDialog() {
    TextEditingController controller =
        TextEditingController(text: daysUntilEvent.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Days Until Event'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of days',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? newDays = int.tryParse(controller.text);
                if (newDays != null && newDays >= 0) {
                  saveDaysValue(newDays);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid number')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool loaded = false;

  Stream<QuerySnapshot> getmessages(token) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return _firestore
        .collection("ticket")
        .doc(token.toString())
        .collection("messages")
        .snapshots();
  }

  int dataIndex = 0;

  Widget listItem({required List<QueryDocumentSnapshot> tickets, index}) {
    // Check if there's only 1 ticket for special design
    bool isSingleTicket = tickets.length == 1;

    return GestureDetector(
      onLongPress: () {
        final eventprovider =
            Provider.of<EventProvider>(context, listen: false);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Delete Ticket',
          desc: 'Are you sure you want to delete ticket',
          btnCancelOnPress: () {
            FormData newdata = FormData(
                artistName: tickets[index]['artistName'],
                eventName: tickets[index]['eventName'],
                section: tickets[index]['section'],
                row: tickets[index]['row'],
                seat: tickets[index]['seat'],
                date: tickets[index]['date'],
                location: tickets[index]['location'],
                time: tickets[index]['time'],
                ticketType: tickets[index]['ticketType'],
                level: tickets[index]['level'],
                numberOfTicket: tickets[index]['numberOfTicket'],
                imageUrl: tickets[index]['image']);
            context.read<FormDataProvider>().updateFormData(newdata);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FormScreen(),
            ));
          },
          btnOkOnPress: () async {
            final eventprovider =
                Provider.of<EventProvider>(context, listen: false);
            //  print(eventprovider.token);
            final FirebaseFirestore _firestore = FirebaseFirestore.instance;

            DocumentReference _docref;
            Future<DocumentSnapshot> _futureDocument;
            _docref = FirebaseFirestore.instance
                .collection("ticket")
                .doc(eventprovider.token.toString());
            _futureDocument = _docref.get();
            List<Map> items = tickets.map((e) => {'id': e.id}).toList();
            print(items[index]['id']);

            await _firestore
                .collection("ticket")
                .doc(eventprovider.token.toString())
                .collection('messages')
                .doc(items[index]['id'])
                .delete();
            setState(() {
              loaded = false;
            });
          },
        ).show();
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventDetailaScreenWithTabbar(
                artistName: tickets[index]['artistName'],
                eventName: tickets[index]['eventName'],
                section: tickets[index]['section'],
                row: tickets[index]['row'],
                seat: tickets[index]['seat'],
                date: tickets[index]['date'],
                location: tickets[index]['location'],
                time: tickets[index]['time'],
                image: tickets[index]['image'],
                ticketType: tickets[index]['ticketType'],
                level: tickets[index]['level'],
                number_of_ticket: tickets[index]['numberOfTicket'])));
      },
      child: isSingleTicket
          ? _buildSingleTicketDesign(tickets, index)
          : _buildMultipleTicketsDesign(tickets, index),
    );
  }

  // Design for single ticket (like the provided image)
  Widget _buildSingleTicketDesign(
      List<QueryDocumentSnapshot> tickets, int index) {
    final colorprov = context.watch<ColorProvider>();
    return Container(
      height: MediaQuery.of(context).size.height * 0.73,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Stack(
            children: [
              // Full-height blurred background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(tickets[index]['image']),
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              // Main sharp image positioned in center/upper area
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                bottom: 120,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(tickets[index]['image']),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.3, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ),
              // Content overlay
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Next Event" header
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: toggleEventText,
                                child: Text(
                                  showNextEvent
                                      ? 'Next Event:'
                                      : 'Enjoy your event',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              showNextEvent
                                  ? GestureDetector(
                                      onTap: showEditDaysDialog,
                                      child: Text(
                                        ' $daysUntilEvent ${daysUntilEvent == 1 ? 'day' : 'days'}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                          SvgPicture.asset(
                            'assets/images/add-calendar.svg',
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Bottom content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 6),
                            child: Text(
                              '${tickets[index]['date']} • ${tickets[index]['time']}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            color: Colors.black,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.black,
                                  child: Text(
                                    tickets[index]['eventName'] == ''
                                        ? tickets[index]['artistName']
                                            .toUpperCase()
                                        : '${tickets[index]['artistName'].toUpperCase()}: ${tickets[index]['eventName'].toUpperCase()}',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.2,
                                      letterSpacing: 0.5,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Divider line
                                Container(
                                  height: 4,
                                  width: 180,
                                  color: Colors.grey.withOpacity(0.8),
                                ),
                                const SizedBox(height: 8),
                                // Location
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Text(
                                        tickets[index]['location'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/myevent.png',
                                              height: 20,
                                              width: 20,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'X${tickets[index]['numberOfTicket'].toString()}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // View Tickets button
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailaScreenWithTabbar(
                                            artistName: tickets[index]
                                                ['artistName'],
                                            eventName: tickets[index]
                                                ['eventName'],
                                            section: tickets[index]['section'],
                                            row: tickets[index]['row'],
                                            seat: tickets[index]['seat'],
                                            date: tickets[index]['date'],
                                            location: tickets[index]
                                                ['location'],
                                            time: tickets[index]['time'],
                                            image: tickets[index]['image'],
                                            ticketType: tickets[index]
                                                ['ticketType'],
                                            level: tickets[index]['level'],
                                            number_of_ticket: tickets[index]
                                                ['numberOfTicket'])));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorprov.currentColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                              ),
                              child: const Text(
                                'View Tickets',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Original design for multiple tickets
  Widget _buildMultipleTicketsDesign(
      List<QueryDocumentSnapshot> tickets, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(tickets[index]['image']),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.4, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Date and time at the top
                Container(
                  color: Colors.black,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Text(
                    '${tickets[index]['date']} • ${tickets[index]['time']}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Event title
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.black,
                        child: Text(
                          tickets[index]['eventName'] == ''
                              ? tickets[index]['artistName'].toUpperCase()
                              : '${tickets[index]['artistName'].toUpperCase()}: ${tickets[index]['eventName'].toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: 0.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Divider line
                      Container(
                        height: 4,
                        width: 180,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                      const SizedBox(height: 12),
                      // Location
                      Text(
                        tickets[index]['location'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = context.watch<EventProvider>();
    dataIndex = 0;
    return Scaffold(
        body: StreamBuilder(
      stream: getmessages(eventprovider.token),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!eventprovider.loaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            eventprovider.getlength1(snapshot.data?.docs.length ?? 0);
            eventprovider.updateLoaded(true);
          });
        }
        if (snapshot.data?.docs.isEmpty ?? true) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text("No event added yet !")),
              // child: const Center(child: Text('Empty List')),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final artistName = snapshot.data!.docs[index]['artistName'];
              final sortedDocs = snapshot.data!.docs.toList()
                ..sort((a, b) => a['artistName']
                    .toString()
                    .toLowerCase()
                    .compareTo(b['artistName'].toString().toLowerCase()));
              for (var doc in sortedDocs) {
                print(doc['artistName']);
              }

              return listItem(tickets: sortedDocs, index: index);
            },
          );
        }
      },
    ));
  }
}
