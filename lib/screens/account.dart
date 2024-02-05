import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isSwitched = false;
  bool isSwitched2 = false;

  String _displayText = 'Yosirissantos20@gmail.com';
  String _displayText1 = 'Yosiris';

  bool _isEditing = false;
  bool _isEditing1 = false;

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _textEditingController1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedText();
  }

  _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayText = prefs.getString('saved_text') ?? _displayText;
      _displayText1 = prefs.getString('saved_text1') ?? _displayText1;
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
      body: ListView(children: [
        Column(
          children: [
            Container(
              color: const Color(0xff1e252d),
              height: 90,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: ListView(
                children : [
               Column(
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
                                _saveText(newText, 'saved_text1');
                                setState(() {
                                  _displayText1 = newText;
                                  _isEditing1 = false;
                                });
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
                                _saveText(newText, 'saved_text');
                                setState(() {
                                  _displayText = newText;
                                  _isEditing = false;
                                });
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
          ]),
            ),
            Padding(
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
                        switchRow(
                            image: 'assets/images/notification.png',
                            text: "Receive Notifications?"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  const Text('Location Settings',
                      style: TextStyle(
                          color: Color(0xff1e252d),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Column(
                      children: [
                        locationSettingsRow(
                            image: 'assets/images/location-2.png',
                            text: "My Location",
                            textt: "All of USA"),
                        const SizedBox(
                          height: 15,
                        ),
                        locationSettingsRow(
                            image: 'assets/images/usa-icon.png',
                            text: "My Country",
                            textt: "United States"),
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
                        accountRow(
                            image: 'assets/images/payment.png',
                            text: "Saved Paymment Methods"),
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
            )
          ],
        ),
      ]),
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
            const Icon(
              Icons.edit_calendar,
              color: Colors.blue,
            )
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
        const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.grey,
          size: 35,
        )
      ],
    );
  }
}
