// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/event_details_screen.dart';
import 'package:ticketmaster/screens/form_screen.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    context.read<EventProvider>().loadSavedData();

    gettoken();
  }

  int token = 0;
  void gettoken() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getInt('token') ?? 0;
    });
  }

  Query getlist(token) {
    Query dbref = FirebaseDatabase.instance.ref().child('ticket/$token');
    return dbref;
  }

  int dataIndex = 0;

  Widget listItem({required Map tickets}) {
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
                artistName: tickets['artistName'],
                eventName: tickets['eventname'],
                section: tickets['section'],
                row: tickets['row'],
                seat: tickets['seat'],
                date: tickets['date'],
                location: tickets['location'],
                time: tickets['time'],
                ticketType: tickets['ticketype'],
                level: tickets['level'],
                numberOfTicket: tickets['numticket']);
            context.read<FormDataProvider>().updateFormData(newdata);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FormScreen(),
            ));
          },
          btnOkOnPress: () {
            Query refrence =
                FirebaseDatabase.instance.ref().child('ticket/$token');
            refrence.ref.child(tickets['key']).remove();
          },
        ).show();
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventDetails(
              artistName: tickets['artistName'],
              eventName: tickets['eventname'],
              section: tickets['section'],
              row: tickets['row'],
              seat: tickets['seat'],
              date: tickets['date'],
              location: tickets['location'],
              time: tickets['time'],
              image: tickets['image'],
              ticketType: tickets['ticketype'],
              level: tickets['level'],
              number_of_ticket: tickets['numticket']),
        ));
      },
      child: Container(
          margin: const EdgeInsets.only(right: 3, left: 3, bottom: 3),
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                tickets['image'], // Replace with your image URL
              ),
            ),
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.025,
              color: Colors.transparent,
              child: const Center(
                  child: Text(
                "NEW DATE",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.transparent,
                    fontWeight: FontWeight.w500),
              )),
            ),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 160,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(.98),
                ],
                stops: const [0.0, 1],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
              )),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(minHeight: 1, minWidth: 1),
                          child: Text(
                            tickets['eventname'] == ''
                                ? tickets['artistName']
                                : tickets['artistName'] +
                                    ' | ' +
                                    tickets['eventname'],
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            Text(
                              tickets['date'] + " " + tickets['time'] + " ",
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              height: 3,
                              width: 3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2.5)),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Text(
                              tickets['location'],
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 13,
                            height: 13,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/ticket.png',
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            tickets['numticket'].toString() == '1'
                                ? tickets['numticket'].toString().toString() +
                                    " ticket"
                                : tickets['numticket'].toString().toString() +
                                    " tickets",
                            style: const TextStyle(
                                fontSize: 13,
                                // fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = context.watch<EventProvider>();
    return Scaffold(
        body: FirebaseAnimatedList(
      defaultChild: const Center(child: CircularProgressIndicator()),
      query: getlist(eventprovider.token),
      itemBuilder: (context, snapshot, animation, index) {
        dataIndex += 1;
        Map ticket = snapshot.value as Map;
        // ignore: avoid_print
        print(ticket);
        ticket['key'] = snapshot.key;

        if (dataIndex == 0) {
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
          return listItem(tickets: ticket);
        }
      },
    ));
  }
}
