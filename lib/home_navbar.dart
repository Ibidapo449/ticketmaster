import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmaster/home.dart';
import 'package:ticketmaster/providers/event_providers.dart';

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
    Container(),
  ];
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
              icon: Padding(
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
              label: 'My Account',
            ),
          ],
        ),
      ),
    );
  }
}
