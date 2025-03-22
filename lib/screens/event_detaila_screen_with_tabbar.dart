// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/TabbarPage/past.dart';
import 'package:ticketmaster/screens/TabbarPage/upcoming.dart';
import 'package:ticketmaster/screens/TabbarPageforEventsDetails/add_ons.dart';
import 'package:ticketmaster/screens/TabbarPageforEventsDetails/tabbar_my_tickets.dart';
import 'package:ticketmaster/screens/form_screen.dart';
import 'package:ticketmaster/screens/my_tickets.dart';

class EventDetailaScreenWithTabbar extends StatefulWidget {
  const EventDetailaScreenWithTabbar({super.key});

  @override
  State<EventDetailaScreenWithTabbar> createState() => _HomePageState();
}

class _HomePageState extends State<EventDetailaScreenWithTabbar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = context.watch<EventProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f262e),
        leading: Padding(
          padding: const EdgeInsets.all(17.0),
          child: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: const SizedBox(
              height: 20,
              width: 20,
              // child: Image.asset(
              //   "assets/images/cancel.png",
              //   color: Colors.white,
              // ),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 25, 114, 210),
                ),
                child: Column(
                  children: [
                    TabBar(
                        unselectedLabelColor: Colors.white54,
                        labelStyle: const TextStyle(color: Colors.white),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        controller: tabController,
                        tabs: const [
                          Tab(text: "MY TICKETS(1)"),
                          Tab(
                            text: "ADD-0NS(0)",
                          )
                        ])
                  ],
                )),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: const [TabbarMyTickets(), AddOns()],
            ))
          ],
        ),
      ),
    );
  }
}
