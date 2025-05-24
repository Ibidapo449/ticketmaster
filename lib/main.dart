import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/firebase_options.dart';
import 'package:ticketmaster/home_navbar.dart';
import 'package:ticketmaster/providers/TimerProvider.dart';
import 'package:ticketmaster/providers/croppedImageProvider.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ticketmaster/screens/login_screen.dart';

import 'providers/colorProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  final string = pref.getString('accesstime');

  runApp(MyApp(
    islogged: string,
  ));
}

class MyApp extends StatelessWidget {
  final String? islogged;
  const MyApp({super.key, required this.islogged});

  @override
  Widget build(BuildContext context) {
    createrandom();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => FormDataProvider()),
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => TimerProvider()),
        ChangeNotifierProvider(create: (context) => CroppedImageProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: islogged == null ? SignIn() : HomeNavBar(),
        // home: const SignIn(),
      ),
    );
  }
}

void createrandom() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
