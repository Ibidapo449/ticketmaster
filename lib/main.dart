import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmaster/home_navbar.dart';
import 'package:ticketmaster/providers/event_providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeNavBar(),
      ),
    );
  }
}


