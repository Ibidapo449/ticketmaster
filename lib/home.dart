// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmaster/screens/event_details_screen.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/form_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    context.read<EventProvider>().loadSavedData();
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = context.watch<EventProvider>();
    print(eventprovider.image);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1f262e),
        leading: const Icon(
          Icons.ac_unit,
          color: Color(0xff1f262e),
        ),
        title: const Text(
          "My Events",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FormScreen(),
              ));
            },
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
      body: eventprovider.image == ''
          ? Padding(
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
            )
          : GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EventDetails(),
                ));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      eventprovider.image, // Replace with your image URL
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.0, 1.0],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: ConstrainedBox(
                                constraints:
                                    BoxConstraints(minHeight: 1, minWidth: 1),
                                child: Text(
                                  eventprovider.eventName == ''
                                      ? eventprovider.artistName
                                      : eventprovider.artistName +
                                          ' | ' +
                                          eventprovider.eventName,
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
                                    // event.name,
                                    eventprovider.date +
                                        " " +
                                        eventprovider.time +
                                        " ",
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
                                        borderRadius:
                                            BorderRadius.circular(2.5)),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    eventprovider.location,
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
                                  eventprovider.numberOfTicket.toString() == '1'
                                      ? eventprovider.numberOfTicket
                                              .toString() +
                                          " ticket"
                                      : eventprovider.numberOfTicket
                                              .toString() +
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
                  ],
                ),
              ),
            ),
    );
  }
}
