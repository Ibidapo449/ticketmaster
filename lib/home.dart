// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    _loadSavedData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EventProvider>(context, listen: false).getAllEvents();
    });
  }
   String _date = '';
  String _eventName = '';
  String _time = '';
  String _location = '';
  // String _email = '';


  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _date = prefs.getString('date') ?? 'N/A';
      _eventName = prefs.getString('eventName') ?? 'N/A';
      _time = prefs.getString('eventName') ?? 'N/A';
      _location = prefs.getString('location') ?? 'N/A';
      // _email = prefs.getString('email') ?? 'N/A';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.ac_unit,
          color: Colors.black,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Events"),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FormScreen(),
                  ));
                },
                child: const Text("Help"),
              ),
            ],
          ),
        ),
      ),
      body: 
                   GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EventDetails(),
                      ));
                    },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSs6uOkARyMvSA4MJUzIa-8KnWZeDn_VT4Zcg&usqp=CAU', // Replace with your image URL
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
                      Text(
                        _eventName,
                        style: const TextStyle(fontSize: 25, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                        Text(
                        // event.name,
                         _date + " " + _time +  " " + _location,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
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
                          const Text(
                            "1",
                            style:  TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
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
      // body: Consumer<EventProvider>(
      //   builder: (context, value, child) {
      //     final events = value.events;
      //     return ListView.builder(
      //         itemCount: events.length,
      //         itemBuilder: (context, index) {
      //           final event = events[index];
      //           return Padding(
      //             padding: const EdgeInsets.symmetric(vertical: 10),
      //             child: GestureDetector(
      //               onTap: () {
      //                 Navigator.of(context).push(MaterialPageRoute(
      //                   builder: (context) => const EventDetails(),
      //                 ));
      //               },
      //               child: Container(
      //                 height: MediaQuery.of(context).size.height * 0.25,
      //                 decoration: const BoxDecoration(
      //                   image: DecorationImage(
      //                     fit: BoxFit.cover,
      //                     image: NetworkImage(
      //                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSs6uOkARyMvSA4MJUzIa-8KnWZeDn_VT4Zcg&usqp=CAU', // Replace with your image URL
      //                     ),
      //                   ),
      //                 ),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Container(
      //                       height: MediaQuery.of(context).size.height * 0.025,
      //                       color: Colors.transparent,
      //                       child: const Center(
      //                           child: Text(
      //                         "NEW DATE",
      //                         style: TextStyle(
      //                             fontSize: 12,
      //                             color: Colors.transparent,
      //                             fontWeight: FontWeight.w500),
      //                       )),
      //                     ),
      //                     const Spacer(),
      //                     Container(
      //                       width: MediaQuery.of(context).size.width,
      //                       decoration: const BoxDecoration(
      //                           gradient: LinearGradient(
      //                         colors: [
      //                           Colors.transparent,
      //                           Colors.black,
      //                         ],
      //                         stops: [0.0, 1.0],
      //                         begin: FractionalOffset.topCenter,
      //                         end: FractionalOffset.bottomCenter,
      //                       )),
      //                       child: Padding(
      //                         padding:
      //                             const EdgeInsets.symmetric(horizontal: 15),
      //                         child: Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             const Text(
      //                               "The Eras Tour",
      //                               style: TextStyle(
      //                                   fontSize: 25, color: Colors.white),
      //                             ),
      //                             const SizedBox(
      //                               height: 4,
      //                             ),
      //                             Text(
      //                               event.name,
      //                               // "Sun, Aug 5, 6:30pm. SoFi Stadium",
      //                               style: const TextStyle(
      //                                   fontSize: 13,
      //                                   fontWeight: FontWeight.w500,
      //                                   color: Colors.white),
      //                             ),
      //                             const SizedBox(
      //                               height: 3,
      //                             ),
      //                             Row(
      //                               children: [
      //                                 Container(
      //                                   width: 13,
      //                                   height: 13,
      //                                   decoration: const BoxDecoration(
      //                                     image: DecorationImage(
      //                                         image: AssetImage(
      //                                           'assets/images/ticket.png',
      //                                         ),
      //                                         fit: BoxFit.cover),
      //                                   ),
      //                                 ),
      //                                 const SizedBox(
      //                                   width: 5,
      //                                 ),
      //                                 Text(
      //                                   event.id.toString(),
      //                                   style: const TextStyle(
      //                                       fontSize: 13,
      //                                       fontWeight: FontWeight.w500,
      //                                       color: Colors.white),
      //                                 ),
      //                               ],
      //                             ),
      //                             const SizedBox(
      //                               height: 10,
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           );
      //         });
      //   },
      // ),
    );
  }
}
