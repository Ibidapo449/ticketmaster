// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/TabbarPage/past.dart';
import 'package:ticketmaster/screens/TabbarPage/upcoming.dart';
import 'package:ticketmaster/screens/form_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f262e),
        leading: const Icon(
          Icons.ac_unit,
          color: Color(0xff1f262e),
        ),
        title: const Text(
          "My Events",
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              FormData newdata = FormData(
                  artistName: '',
                  eventName: '',
                  section: '',
                  row: '',
                  seat: '',
                  date: '',
                  location: '',
                  time: '',
                  ticketType: '',
                  level: '',
                  numberOfTicket: 1);
              context.read<FormDataProvider>().updateFormData(newdata);
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
                          Tab(text: "UPCOMING(3)"),
                          Tab(
                            text: "PAST(0)",
                          )
                        ])
                  ],
                )),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: const [Upcoming(), Past()],
            ))
          ],
        ),
      ),
    );
  }
}
