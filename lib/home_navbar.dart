import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/home.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/Discover_page.dart';
import 'package:ticketmaster/screens/account.dart';
import 'package:ticketmaster/screens/login_screen.dart';
import 'package:ticketmaster/screens/sell_page.dart';

class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int _currentIndex = 0;
  final tabs = [
    const DiscoverPage(),
    Container(),
    const HomePage(),
    const SellPage(),
    const Account(),
  ];
  Timer? _usageTimer;

  bool _fiveMinutesElapsed = false;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startUsageTimer();
    context.read<EventProvider>().getCountry();
    context.read<EventProvider>().getSwitch();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().getMajorEvents();
      context.read<EventProvider>().getMajorEventsSport();
      context.read<EventProvider>().getMajorEventsConcert();
      context.read<EventProvider>().getMajorEventsFamily();
      context.read<EventProvider>().getMajorEventsComedy();

      context.read<EventProvider>().loadSavedData();
    });
  }

  void _startUsageTimer() {
    _usageTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // setState(() {
      _elapsedTime += const Duration(seconds: 10);
      if (_elapsedTime >= const Duration(seconds: 11) && !_fiveMinutesElapsed) {
        _fiveMinutesElapsed = true;
        _onFiveMinutesElapsed();
      }
      // });
    });
  }

  Future<DateTime> getTime() async {
    final pref = await SharedPreferences.getInstance();
    final accessString = pref.getString('accesstime');
    DateTime date;
    date = DateTime.parse(accessString!);
    return date;
  }

  void compareDates(DateTime date2) async {
    DateTime storedTime = await getTime();
    if (storedTime.isAfter(date2)) {
      print("storedTime is more recent than date2");
    } else if (storedTime.isBefore(date2)) {
      final pref = await SharedPreferences.getInstance();
      pref.remove('accesstime');
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => SignIn(),
        ),
        (Route<dynamic> route) => false,
      );
      print("storedTime is earlier than date2");
    } else if (storedTime.isAtSameMomentAs(date2)) {
      print("storedTime and date2 are the same");
    }
  }

  void _onFiveMinutesElapsed() async {
    print("5 minutes of app usage has elapsed!");

    // setState(() {
    _fiveMinutesElapsed = false;
    _elapsedTime = Duration.zero;
    // });
    compareDates(DateTime.now());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usageTimer!.cancel();
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            // color: isSelected
            //     ? const Color.fromARGB(255, 1, 114, 234).withOpacity(.3)
            //     : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Image.asset(
                  iconPath,
                  color: iconPath.contains('sell')
                      ? null
                      : isSelected
                          ? const Color.fromARGB(255, 14, 62, 125)
                          : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected
                      ? const Color.fromARGB(255, 14, 62, 125)
                      : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<EventProvider>().loadSavedData();
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 25),
          child: Row(
            children: [
              _buildNavItem(
                iconPath: 'assets/images/search.png',
                label: 'Discover',
                index: 0,
              ),
              _buildNavItem(
                iconPath: 'assets/images/love.png',
                label: 'For You',
                index: 1,
              ),
              _buildNavItem(
                iconPath: 'assets/images/myevent.png',
                label: 'My Tickets',
                index: 2,
              ),
              _buildNavItem(
                iconPath: 'assets/images/sell.png',
                label: 'Sell',
                index: 3,
              ),
              _buildNavItem(
                iconPath: 'assets/images/person.png',
                label: 'My Account',
                index: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
