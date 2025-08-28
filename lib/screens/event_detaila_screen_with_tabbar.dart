import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/providers/colorProvider.dart';
import 'package:ticketmaster/screens/TabbarPageforEventsDetails/add_ons.dart';
import 'package:ticketmaster/screens/TabbarPageforEventsDetails/tabbar_my_tickets.dart';

class EventDetailaScreenWithTabbar extends StatefulWidget {
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
  const EventDetailaScreenWithTabbar(
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
  State<EventDetailaScreenWithTabbar> createState() => _HomePageState();
}

class _HomePageState extends State<EventDetailaScreenWithTabbar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool showTabBar = false;
  double _opacity1 = 0;
  double _opacity2 = 0;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getTabbarShow();
    // Fade in animations
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _opacity1 = 1);
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _opacity2 = 1);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void getTabbarShow() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      showTabBar = pref.getBool('ShowTabBar') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: !colorProv.isPrimary
            ? colorProv.currentColor
            : const Color(0xff1f262e),
        leading: Padding(
          padding: const EdgeInsets.all(17.0),
          child: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: const SizedBox(
              height: 20,
              width: 20,
              child: Icon(
                Icons.close,
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
                child: Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () async {
                      final pref = await SharedPreferences.getInstance();
                      pref.setBool('ShowTabBar', !showTabBar);
                      getTabbarShow();
                      print(widget.image);
                    },
                    child: const Text(
                      'Help',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
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
            showTabBar
                ? Container(
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: colorProv.currentColor,
                      // color: Color.fromARGB(255, 25, 114, 210),
                    ),
                    child: Column(
                      children: [
                        TabBar(
                            unselectedLabelColor: Colors.white54,
                            labelStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: Colors.white,
                            indicatorWeight: 3,
                            controller: tabController,
                            tabs: const [
                              Tab(text: "MY TICKETS"),
                              Tab(
                                text: "ADD-ONS",
                              )
                            ])
                      ],
                    ))
                : const SizedBox(),
            Expanded(
                child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                TabbarMyTickets(
                  opacity1: _opacity1,
                  opacity2: _opacity2,
                  artistName: widget.artistName,
                  eventName: widget.eventName,
                  section: widget.section,
                  row: widget.row,
                  seat: widget.seat,
                  date: widget.date,
                  location: widget.location,
                  time: widget.time,
                  image: widget.image,
                  ticketType: widget.ticketType,
                  level: widget.level,
                  number_of_ticket: widget.number_of_ticket,
                ),
                const AddOns()
              ],
            ))
          ],
        ),
      ),
    );
  }
}
