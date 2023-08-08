import 'package:flutter/material.dart';
import 'package:ticketmaster/home.dart';

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
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 15,
          backgroundColor: Colors.white,
          selectedFontSize: 13,
          unselectedFontSize: 13,
          selectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          enableFeedback: true,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // selectedLabelStyle: const TextStyle(
          //   color: Colors.blue,
          //   fontSize: 15,
          //   fontWeight: FontWeight.w400,
          // ),
          unselectedLabelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/search.png',),
                      fit: BoxFit.cover),
                ),
              ),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
               icon: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/love.png',),
                      fit: BoxFit.cover),
                ),
              ),
              label: 'Favourites',
            ),
            BottomNavigationBarItem(
               icon: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/myevent.png',),
                      fit: BoxFit.cover),
                ),
              ),
              label: 'My Events',
            ),
            BottomNavigationBarItem(
               icon: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/person.png',),
                      fit: BoxFit.cover),
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
