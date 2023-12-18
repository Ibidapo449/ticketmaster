import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/home_navbar.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // FirebaseDatabase.instance();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBd2yXeP9VMzRoD961WSpAfdHFBgIftogU",
        authDomain: "ticket-d5d35.firebaseapp.com",
        databaseURL: "https://ticket-d5d35-default-rtdb.firebaseio.com",
        projectId: "ticket-d5d35",
        storageBucket: "ticket-d5d35.appspot.com",
        messagingSenderId: "172881875812",
        appId: "1:172881875812:web:9e4809d1e8148d55eba071"),
  );
  runApp(const MyApp());
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
