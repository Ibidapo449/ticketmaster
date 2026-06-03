import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/screens/admin.dart';
import 'package:ticketmaster/screens/ticket_transfer_page.dart';

import '../providers/event_providers.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int visibleContainerIndex = 0;

  void switchContainer() {
    setState(() {
      visibleContainerIndex = (visibleContainerIndex + 1) % 3;
    });
  }

  int visibleContainerIndex1 = 0;

  void switchContainer1() {
    setState(() {
      visibleContainerIndex1 = (visibleContainerIndex1 + 1) % 3;
    });
  }

  bool isSwitched = false;
  bool isSwitched2 = false;

  String _displayText = 'Yosirissantos20@gmail.com';
  String _displayText1 = 'Yosiris';

  bool _isEditing = false;
  bool _isEditing1 = false;

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController1 = TextEditingController();
  // Replace specific Canada-only fields with generic lists for all options
  List<String> _myLocationTexts = ['All of USA', 'All of Uk', 'All of Canada'];
  List<String> _myCountryTexts = ['United States', 'United Kingdom', 'Canada'];
  String _myLocationCanadaText = 'All of Canada';
  String _myCountryCanadaText = 'Canada';
  final TextEditingController _editController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedText();
    getSwitch();
  }

  _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayText = prefs.getString('saved_text') ?? _displayText;
      _displayText1 = prefs.getString('saved_text1') ?? _displayText1;
      for (int i = 0; i < 3; i++) {
        final loc = prefs.getString('my_location_text_$i');
        if (loc != null) _myLocationTexts[i] = loc;
        final ctr = prefs.getString('my_country_text_$i');
        if (ctr != null) _myCountryTexts[i] = ctr;
      }
      // Backward compatibility for previous single-field implementation
      final legacyLocCanada = prefs.getString('my_location_canada_text');
      if (legacyLocCanada != null) _myLocationTexts[2] = legacyLocCanada;
      final legacyCountryCanada = prefs.getString('my_country_canada_text');
      if (legacyCountryCanada != null) _myCountryTexts[2] = legacyCountryCanada;
    });
  }

  _saveText(String newText, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, newText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        elevation: 0,
        backgroundColor: const Color(0xff1e252d),
        title: const Center(
          child: Text('My Account',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xff1e252d),
            height: 90,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _isEditing1 = true;
                      _textEditingController1.text = _displayText1;
                    });
                  },
                  child: _isEditing1
                      ? TextField(
                          controller: _textEditingController1,
                          style: const TextStyle(color: Colors.white),
                          onSubmitted: (newText) {
                            if (newText.isNotEmpty) {
                              _saveText(newText, 'saved_text1');
                              setState(() {
                                _displayText1 = newText;
                                _isEditing1 = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Name cannot be empty'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        )
                      : Text(
                          _displayText1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onLongPress: () {
                    setState(() {
                      _isEditing = true;
                      _textEditingController.text = _displayText;
                    });
                  },
                  child: _isEditing
                      ? TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: _textEditingController,
                          onSubmitted: (newText) {
                            if (newText.isNotEmpty) {
                              _saveText(newText, 'saved_text');
                              setState(() {
                                _displayText = newText;
                                _isEditing = false;
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('email cannot be empty'),
                                backgroundColor: Colors.red,
                              ));
                            }
                          },
                        )
                      : Text(
                          _displayText,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Notifications',
                      style: TextStyle(
                          color: Color(0xff1e252d),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: Column(
                      children: [
                        accountRow(
                            image: 'assets/images/message-email.png',
                            text: "My Notifications"),
                        const SizedBox(
                          height: 10,
                        ),
                        switchRow2(
                            image: 'assets/images/notification.png',
                            text: "Receive Notifications?"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      const Text('Location Settings',
                          style: TextStyle(
                              color: Color(0xff1e252d),
                              fontWeight: FontWeight.bold,
                              fontSize: 20)),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'NEW!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            switchContainer1();
                          },
                          onLongPress: () {
                            final idx = visibleContainerIndex1;
                            _showEditDialog(
                              title: 'Edit Location',
                              initialText: _myLocationTexts[idx],
                              onSaved: (newText) {
                                _saveText(newText, 'my_location_text_$idx');
                                setState(() {
                                  _myLocationTexts[idx] = newText;
                                });
                              },
                            );
                          },
                          child: Stack(children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: visibleContainerIndex1 == 0 ? 1.0 : 0.0,
                              child: locationSettingsRow(
                                  image: 'assets/images/location-2.png',
                                  text: "My Location",
                                  textt: _myLocationTexts[0]),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: visibleContainerIndex1 == 1 ? 1.0 : 0.0,
                              child: locationSettingsRow(
                                  image: 'assets/images/location-2.png',
                                  text: "My Location",
                                  textt: _myLocationTexts[1]),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: visibleContainerIndex1 == 2 ? 1.0 : 0.0,
                              child: locationSettingsRow(
                                  image: 'assets/images/location-2.png',
                                  text: "My Location",
                                  textt: _myLocationTexts[2]),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            switchContainer();
                          },
                          onLongPress: () {
                            final idx = visibleContainerIndex;
                            _showEditDialog(
                              title: 'Edit Country',
                              initialText: _myCountryTexts[idx],
                              onSaved: (newText) {
                                _saveText(newText, 'my_country_text_$idx');
                                setState(() {
                                  _myCountryTexts[idx] = newText;
                                });
                              },
                            );
                          },
                          child: Stack(children: [
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: visibleContainerIndex == 0 ? 1.0 : 0.0,
                              child: locationSettingsRow(
                                  image: 'assets/images/usa-icon.png',
                                  text: "My Country",
                                  textt: _myCountryTexts[0]),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: visibleContainerIndex == 1 ? 1.0 : 0.0,
                              child: locationSettingsRow(
                                  image: 'assets/images/Ellipse 2.png',
                                  text: "My Country",
                                  textt: _myCountryTexts[1]),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: visibleContainerIndex == 2 ? 1.0 : 0.0,
                              child: locationSettingsRow(
                                  image: 'assets/images/Ellipse 3.png',
                                  text: "My Country",
                                  textt: _myCountryTexts[2]),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        switchRow(
                            image: 'assets/images/location.png',
                            text: "Location Based Content"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text('Preferences',
                      style: TextStyle(
                          color: Color(0xff1e252d),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      children: [
                        accountRow(
                            image: 'assets/images/heart.png',
                            text: "My Favorites"),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const TransferTicketPage(),
                            ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/Vector 1.svg',
                                    height: 22,
                                    width: 22,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text(
                                    "Saved Payment Methods",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff1e252d),
                                        fontSize: 18),
                                  )
                                ],
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right,
                                color: Colors.grey,
                                size: 35,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        accountRow(
                            image: 'assets/images/change-app.png',
                            text: "Change App Icon"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text('Help & Guidance',
                      style: TextStyle(
                          color: Color(0xff1e252d),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      children: [
                        accountRow(
                            image: 'assets/images/help.png',
                            text: "Need Help?"),
                        const SizedBox(
                          height: 10,
                        ),
                        accountRow(
                            image: 'assets/images/pencil.png',
                            text: "Give Us Feedback"),
                        const SizedBox(
                          height: 10,
                        ),
                        accountRow(
                            image: 'assets/images/legal.png', text: "Legal"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/sign-out.png'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Sign out',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                            fontSize: 18),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row switchRow({required String image, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
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
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1e252d),
                  fontSize: 18),
            )
          ],
        ),
        CupertinoSwitch(
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;
            });
          },
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Row switchRow2({required String image, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
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
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1e252d),
                  fontSize: 18),
            )
          ],
        ),
        CupertinoSwitch(
          value: context.watch<EventProvider>().isSwitched2,
          onChanged: (value) {
            // setState(() {
            //   isSwitched2 = value;
            // });
            // bool isSwitched = !isSwitched2;

            changeSwitch(value);
          },
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  void changeSwitch(value) async {
    bool switchVal = true;

    final pref = await SharedPreferences.getInstance();
    pref.setBool('LazyLoad', value);
    switchVal = pref.getBool('LazyLoad') ?? true;
    context.read<EventProvider>().getSwitch();
    setState(() {
      isSwitched2 = switchVal;
    });
  }

  void getSwitch() async {
    bool switchVal = true;

    final pref = await SharedPreferences.getInstance();

    switchVal = pref.getBool('LazyLoad') ?? true;
    print(switchVal);
    setState(() {
      isSwitched2 = switchVal;
    });
  }

  Row locationSettingsRow(
      {required String image, required String text, required String textt}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
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
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1e252d),
                  fontSize: 18),
            )
          ],
        ),
        Row(
          children: [
            Text(
              textt,
              style: const TextStyle(
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/Group 3.png',
                    ),
                    fit: BoxFit.cover),
              ),
            ),
          ],
        )
      ],
    );
  }

  Row accountRow({required String image, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
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
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff1e252d),
                  fontSize: 18),
            )
          ],
        ),
        InkWell(
          onTap: () async {
            final pref = await SharedPreferences.getInstance();
            final email = pref.getString('accessAccount');
            if (email == 'caleboruta.co@gmail.com') {
              if (mounted) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AdminPage(),
                ));
              }
            }
          },
          child: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
            size: 35,
          ),
        )
      ],
    );
  }

  Future<void> _showEditDialog({
    required String title,
    required String initialText,
    required void Function(String) onSaved,
  }) async {
    _editController.text = initialText;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _editController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter new value',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newText = _editController.text.trim();
                if (newText.isNotEmpty) {
                  onSaved(newText);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Value cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
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
}
