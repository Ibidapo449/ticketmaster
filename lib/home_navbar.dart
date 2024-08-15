import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/home.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/account.dart';
import 'package:ticketmaster/screens/login_screen.dart';

class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int _currentIndex = 0;
  final tabs = [
    Container(),
    Container(),
    const HomePage(),
    Container(),
    Account(),
  ];
  Timer? _usageTimer;

  bool _fiveMinutesElapsed = false;
  Duration _elapsedTime = Duration.zero;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startUsageTimer();
  }

  void _startUsageTimer() {
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
        if (_elapsedTime >= const Duration(minutes: 1) &&
            !_fiveMinutesElapsed) {
          _fiveMinutesElapsed = true;
          _onFiveMinutesElapsed();
        }
      });
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

    setState(() {
      _fiveMinutesElapsed = false;
      _elapsedTime = Duration.zero;
    });
    compareDates(DateTime.now());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _usageTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    context.read<EventProvider>().loadSavedData();
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
        height: 100,
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 15,
          backgroundColor: Colors.white,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          currentIndex: _currentIndex,
          selectedItemColor: const Color(0xff0267d3).withOpacity(.9),
          unselectedItemColor: Colors.grey,
          enableFeedback: true,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedLabelStyle: const TextStyle(
            color: Color(0xff45688d),
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/search.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/love.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
              icon: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/myevent.png',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              activeIcon: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Color(0xff0267d3), BlendMode.srcIn),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/myevent.png',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              label: 'My Events',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/sell.png',
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              label: 'Sell',
            ),
            BottomNavigationBarItem(
              activeIcon: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Color(0xff0267d3), BlendMode.srcIn),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/person.png',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              icon: ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'assets/images/person.png',
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              label: 'My Account',
            ),
          ],
        ),
      ),
    );
  }
}
