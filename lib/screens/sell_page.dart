// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/home.dart';
import 'package:ticketmaster/home_navbar.dart';
import 'package:ticketmaster/screens/event_details_screen.dart';


class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final _formKey = GlobalKey<FormState>();
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;

  Future<void> startCountdown() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final countdownDuration = Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );

      final endTime = DateTime.now().add(countdownDuration);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('countdownEndTime', endTime.millisecondsSinceEpoch);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeNavBar()
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Countdown Timer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Colors.transparent,
                    height: 50,
                    width: 70,
                    child: TextFormField(
                      decoration: const InputDecoration(
                  errorStyle:  TextStyle(
                    fontSize: 12,
                    
                  ),
                  focusedErrorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                 floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Days",
                  labelStyle:  TextStyle(
                    fontSize: 14,
                  ),
                  
                  focusedBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color:Colors.black, width: 1.0),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                      keyboardType: TextInputType.number,
                      
                      onSaved: (value) => days = int.tryParse(value ?? '0') ?? 0,
                    ),
                  ),
              
              
                  Container(
                     color: Colors.transparent,
                    height: 50,
                    width: 70,
                    child: TextFormField(
                      decoration: const InputDecoration(
                  errorStyle:  TextStyle(
                    fontSize: 12,
                    
                  ),
                  focusedErrorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                 floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Hours",
                  labelStyle:  TextStyle(
                    fontSize: 14,
                  ),
                  
                  focusedBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color:Colors.black, width: 1.0),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => hours = int.tryParse(value ?? '0') ?? 0,
                    ),
                  ),
                  Container(
                     color: Colors.transparent,
                    height: 50,
                    width: 70,
                    child: TextFormField(
                    decoration: const InputDecoration(
                  errorStyle:  TextStyle(
                    fontSize: 12,
                    
                  ),
                  focusedErrorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                 floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Minutes",
                  labelStyle:  TextStyle(
                    fontSize: 14,
                  ),
                  
                  focusedBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color:Colors.black, width: 1.0),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => minutes = int.tryParse(value ?? '0') ?? 0,
                    ),
                  ),
                  Container(
                     color: Colors.transparent,
                    height: 50,
                    width: 70,
                    child: TextFormField(
                     decoration: const InputDecoration(
                  errorStyle:  TextStyle(
                    fontSize: 12,
                    
                  ),
                  focusedErrorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                 floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Seconds",
                  labelStyle:  TextStyle(
                    fontSize: 14,
                  ),
                  
                  focusedBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color:Colors.black, width: 1.0),
                  ),
                  enabledBorder:  OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => seconds = int.tryParse(value ?? '0') ?? 0,
                    ),
                  ),
                  
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: startCountdown,
                  child: Text("Start Countdown"),
                ),
              ),
            ],
          ),
          
        ),
        
      ),
    );
  }
}