import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/home_navbar.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});
  TextEditingController _controller = TextEditingController();
  void saveAccessTime() async {
    final pref = await SharedPreferences.getInstance();
    DateTime currentTime = DateTime.now();

    // Add 5 minutes to the current time
    DateTime newTime = currentTime.add(Duration(days: 2));

    pref.setString('accesstime', newTime.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color(0xffE9EAF7),
              Color(0xffF4EEF2),
              Color(0xffEBEBF2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 250),
              const Text(
                "Hello, Chairman.",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 18, color: Colors.black, height: 1.2),
              ),
              SizedBox(height: size.height * 0.04),
              // for username and password
              myTextField("Email address", Colors.white),

              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // for sign in button
                    GestureDetector(
                      onTap: () {
                        FirebaseFirestore db = FirebaseFirestore.instance;
                        // final docRef = db.collection("users");
                        SmartDialog.showLoading();
                        db
                            .collection("user")
                            .where("email",
                                isEqualTo: _controller.text.toLowerCase())
                            .get()
                            .then((QuerySnapshot querySnapshot) {
                          if (querySnapshot.docs.isNotEmpty) {
                            // for (var doc in querySnapshot.docs) {
                            //   print("Document Data: ${doc.data()}");
                            // }

                            for (var doc in querySnapshot.docs) {
                              print(doc.data());
                              Map<String, dynamic> response =
                                  doc.data() as Map<String, dynamic>;
                              if (response['access'] == true) {
                                SmartDialog.dismiss();
                                SmartDialog.showToast(
                                    'Account Validated Successfully');
                                saveAccessTime();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeNavBar(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                SmartDialog.dismiss();
                                SmartDialog.showToast(
                                    'You don\'t have access for this operation');
                              }
                            }
                          } else {
                            print("No matching documents found");
                            SmartDialog.dismiss();
                            SmartDialog.showToast(
                                'No matching documents found');
                          }
                        }).catchError((error) {
                          print("Error getting documents: $error");
                          SmartDialog.dismiss();
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xff1f262e),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container myTextField(String hint, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 22,
            ),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15),
            ),
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.black45,
              fontSize: 17,
            ),
            suffixIcon: Icon(
              Icons.visibility_off_outlined,
              color: color,
            )),
      ),
    );
  }
}
