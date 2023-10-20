import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/home_navbar.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
  // FirebaseDatabase.instance().i
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    createrandom();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => FormDataProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeNavBar(),
      ),
    );
  }
}

void createrandom() async {
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();

  final token = pref.getInt('token');

  if (token == null) {
    var rng = new Random();
    var code = rng.nextInt(900000000) + 100000000;

    pref.setInt('token', code);
    final dbref = FirebaseDatabase.instance.ref();

    final token = pref.getInt('token');
    dbref.child('user').set({'id': token, "validity": "true"});
  }
}
