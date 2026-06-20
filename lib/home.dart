// ignore_for_file: prefer_interpolation_to_compose_strings, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  int visibleContainerIndex1 = 0;
  int pastEventsCount = 0;
  final TextEditingController _eventSearchController = TextEditingController();
  final FocusNode _eventSearchFocusNode = FocusNode();
  bool _showEventSearch = false;
  String _eventSearchQuery = '';

  final List<Map<String, String>> _flags = [
    {'emoji': '🇬🇧', 'label': 'UK'},
    {'emoji': '🇨🇦', 'label': 'Canada'},
    {'emoji': '🇺🇸', 'label': 'USA'},
    {'emoji': '🇫🇷', 'label': 'France'},
    {'emoji': '🇪🇸', 'label': 'Spain'},
    {'emoji': '🇲🇽', 'label': 'Mexico'},
    {'emoji': '🇩🇪', 'label': 'Germany'},
    {'emoji': '🇳🇱', 'label': 'Netherlands'},
    {'emoji': '🇮🇹', 'label': 'Italy'},
    {'emoji': '🇮🇪', 'label': 'Ireland'},
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _loadVisibleContainerIndex();
    _loadPastEventsCount();
  }

  Future<void> _loadVisibleContainerIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('visibleContainerIndex1') ?? 0;
    setState(() {
      visibleContainerIndex1 = savedIndex;
    });
  }

  Future<void> _saveVisibleContainerIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('visibleContainerIndex1', index);
  }

  Future<void> _loadPastEventsCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pastEventsCount = prefs.getInt('pastEventsCount') ?? 0;
    });
  }

  Future<void> _savePastEventsCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pastEventsCount', count);
    setState(() {
      pastEventsCount = count;
    });
  }

  void _showEditPastEventsDialog() {
    TextEditingController countController =
        TextEditingController(text: pastEventsCount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Past Events Count'),
          content: TextField(
            controller: countController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Number of past events',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                int? newCount = int.tryParse(countController.text);
                if (newCount != null && newCount >= 0) {
                  _savePastEventsCount(newCount);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid number')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void switchContainer1() {
    final newIndex = (visibleContainerIndex1 + 1) % (_flags.length + 1);
    setState(() {
      visibleContainerIndex1 = newIndex;
    });
    _saveVisibleContainerIndex(newIndex);
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
  void dispose() {
    tabController.dispose();
    _eventSearchController.dispose();
    _eventSearchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = context.watch<EventProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 11, 11),
        leading: const Icon(
          Icons.ac_unit,
          color: Color.fromARGB(255, 11, 11, 11),
        ),
        title: GestureDetector(
          onTap: () {
            switchContainer1();
          },
          child: Row(
            children: [
              const SizedBox(width: 80),
              const Text(
                "My Events",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Stack(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: visibleContainerIndex1 == 0 ? 1.0 : 0.0,
                    child: Container(
                      width: 20,
                      height: 20,
                      color: const Color(0xff1f262e),
                    ),
                  ),
                  ..._flags.asMap().entries.map((entry) {
                    final flagIndex = entry.key + 1;
                    final emoji = entry.value['emoji']!;
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: visibleContainerIndex1 == flagIndex ? 1.0 : 0.0,
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  }),
                ],
              ),
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
                  address: '',
                  level: '',
                  numberOfTicket: 1);
              context.read<FormDataProvider>().updateFormData(newdata);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FormScreen(),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      decorationColor: Colors.white,
                      decorationThickness: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: _showEventSearch
                  ? Container(
                      key: const ValueKey('event-search'),
                      color: Colors.black,
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
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
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    TabBar(
                        unselectedLabelColor: Colors.white54,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: Colors.white,
                        indicatorWeight: 3,
                        controller: tabController,
                        tabs: [
                          Tab(text: "UPCOMING(${eventprovider.datalength})"),
                          GestureDetector(
                            onTap: () {
                              _showEditPastEventsDialog();
                            },
                            child: Tab(
                              text: "PAST($pastEventsCount)",
                            ),
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
}
