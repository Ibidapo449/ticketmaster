import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool isSwitched = false;
  bool isSwitched2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        elevation: 0,
        backgroundColor: Color(0xff1e252d),
        title: const Text('My Account',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xff1e252d),
            height: 90,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yosiris',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Yosirissantos20@gmail.com',
                  style: TextStyle(
                      color: Color.fromARGB(255, 203, 203, 203), fontSize: 15),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: ListView(
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
                          icon: Icons.email_outlined, text: "My Notifications"),
                      const SizedBox(
                        height: 10,
                      ),
                      switchRow(
                          icon: Icons.notifications,
                          text: "Receive Notifications"),
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
                          icon: Icons.location_history_outlined,
                          text: "My Location",
                          textt: "All of USA"),
                      const SizedBox(
                        height: 15,
                      ),
                      locationSettingsRow(
                          icon: Icons.location_history_outlined,
                          text: "My Country",
                          textt: "United States"),
                      const SizedBox(
                        height: 15,
                      ),
                      switchRow(
                          icon: Icons.notifications,
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
                          icon: Icons.favorite_outline, text: "My Favorites"),
                      const SizedBox(
                        height: 10,
                      ),
                      accountRow(
                          icon: Icons.wallet_outlined,
                          text: "Saved Paymment Methods"),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row switchRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 27,
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
      {required IconData icon, required String text, required String textt}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 27,
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
            Icon(
              Icons.edit_calendar,
              color: Colors.blue,
            )
          ],
        )
      ],
    );
  }

  Row accountRow({required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey,
              size: 27,
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
