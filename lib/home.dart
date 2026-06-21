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
  final TextEditingController _eventSearchController = TextEditingController();
  final FocusNode _eventSearchFocusNode = FocusNode();
  bool _showEventSearch = false;
  String _eventSearchQuery = '';

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _eventSearchController.dispose();
    _eventSearchFocusNode.dispose();
    tabController.dispose();
    super.dispose();
  }

  int visibleContainerIndex1 = 0;

  void switchContainer1() {
    setState(() {
      visibleContainerIndex1 = (visibleContainerIndex1 + 1) % 4;
    });
  }

  void _toggleEventSearch() {
    setState(() {
      _showEventSearch = !_showEventSearch;
      if (!_showEventSearch) {
        _eventSearchController.clear();
        _eventSearchQuery = '';
      }
    });

    if (_showEventSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _eventSearchFocusNode.requestFocus();
        }
      });
    } else {
      _eventSearchFocusNode.unfocus();
    }
  }

  void _clearAndHideSearch() {
    setState(() {
      _showEventSearch = false;
      _eventSearchController.clear();
      _eventSearchQuery = '';
    });
    _eventSearchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = context.watch<EventProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1f262e),
        leading: const Icon(
          Icons.ac_unit,
          color: Color(0xff1f262e),
        ),
        title: GestureDetector(
          onTap: () {
            switchContainer1();
          },
          child: Row(
            children: [
              const SizedBox(
                width: 80,
              ),
              const Text(
                "My Events",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 8,
              ),
              Stack(children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 0 ? 1.0 : 0.0,
                  child: Container(
                    color: const Color(0xff1f262e),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 1 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/usa-icon.png',
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 2 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/Ellipse 2.png',
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 3 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/Ellipse 3.png',
                  ),
                ),
              ]),
            ],
          ),
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
            onLongPress: _toggleEventSearch,
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
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _showEventSearch
                  ? Container(
                      key: const ValueKey('event-search'),
                      color: const Color(0xff1f262e),
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                      child: TextField(
                        controller: _eventSearchController,
                        focusNode: _eventSearchFocusNode,
                        onChanged: (value) {
                          setState(() {
                            _eventSearchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search events',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: _clearAndHideSearch,
                            icon: const Icon(Icons.close),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Container(
                width: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Color(0xff004ee9),
                  // color: Color.fromARGB(255, 25, 114, 210),
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
                        tabs: [
                          Tab(text: "UPCOMING(${eventprovider.datalength})"),
                          const Tab(
                            text: "PAST(0)",
                          )
                        ])
                  ],
                )),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: [
                Upcoming(searchQuery: _eventSearchQuery),
                const Past()
              ],
            ))
          ],
        ),
      ),
    );
  }

  Container myContainer({
    required String image,
  }) {
    return Container(
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                image,
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
