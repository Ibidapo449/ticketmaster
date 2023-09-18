// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/providers/event_providers.dart'; // Import the provider class you created

class FormScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _artistNameController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _rowController = TextEditingController();
  final TextEditingController _seatController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _ticketTypeController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _numberOfTicketsController =
      TextEditingController();

  // final TextEditingController _emailController = TextEditingController();

  FormScreen({super.key});

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, update form data using the provider
      SmartDialog.showLoading();
      FormData newFormData = FormData(
        artistName: _artistNameController.text,
        eventName: _eventNameController.text,
        section: _sectionController.text,
        row: _rowController.text,
        seat: _seatController.text.isEmpty ? '1' : _seatController.text,
        date: _dateController.text,
        location: _locationController.text,
        time: _timeController.text,
        ticketType: _ticketTypeController.text,
        level: _levelController.text,
        numberOfTicket: int.parse(_numberOfTicketsController.text.isEmpty
            ? '1'
            : _numberOfTicketsController.text),
        // email: _emailController.text,
      );
      print(_eventNameController.text);
      await context
          .read<EventProvider>()
          .getAllEvents(_eventNameController.text, _artistNameController.text);
      if (context.read<EventProvider>().error == false) {
        FormDataProvider formDataProvider =
            Provider.of<FormDataProvider>(context, listen: false);
        formDataProvider.updateFormData(newFormData);
        print(Provider.of<EventProvider>(context, listen: false)
            .events[0]
            .images
            .where((element) => element.width == 1024)
            .toList()[0]
            .url);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('artistName', newFormData.artistName);
        prefs.setString('eventName', newFormData.eventName);
        prefs.setString('section', newFormData.section);
        prefs.setString('row', newFormData.row);
        prefs.setString('seat', newFormData.seat);
        prefs.setString('date', newFormData.date);
        prefs.setString('location', newFormData.location);
        prefs.setString('time', newFormData.time);
        prefs.setString('ticketType', newFormData.ticketType);
        prefs.setString('level', newFormData.level);
        prefs.setInt('numberOfTicket', newFormData.numberOfTicket);
        prefs.setString(
            'image',
            Provider.of<EventProvider>(context, listen: false)
                .events[0]
                .images
                .where((element) => element.width == 1024)
                .toList()[0]
                .url);
        SmartDialog.dismiss();
        context.read<EventProvider>().loadSavedData();
        // Show a toast notification
        Fluttertoast.showToast(
          msg: "Event Added successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        SmartDialog.dismiss();

        Fluttertoast.showToast(
          msg: "Check The Artist name and Event Name!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Ticket Generator Form",
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Wrap(children: [
                    Text(
                      'Please fill the form for each ticket item and make sure to click on "Generate Ticket" to add each ticket item.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          // initialValue: getvalue.artistName,
                          controller: _artistNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid artist name';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Artist Name',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          // initialValue: getvalue.eventName,
                          controller: _eventNameController,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Event Name',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          // initialValue: getvalue.section,
                          controller: _sectionController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid section';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Section',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _rowController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter a valid row';
                          //   }
                          //   return null;
                          // },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Row',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _seatController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter a valid seat';
                          //   }
                          //   return null;
                          // },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Seat',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _dateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid date';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'date',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _locationController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid location';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Location',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _timeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid time';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'time',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _ticketTypeController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid ticket Type';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Ticket Type',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _levelController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter a valid level';
                          //   }
                          //   return null;
                          // },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'level',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.42,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        child: TextFormField(
                          controller: _numberOfTicketsController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter a valid ticket Type';
                          //   }
                          //   return null;
                          // },
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              labelText: 'Number of Tickets',
                              border: InputBorder.none,
                              fillColor: Colors.black54,
                              focusColor: Colors.black54),
                        ),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width * 0.42,
                      //   decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.black54),
                      //       borderRadius: BorderRadius.circular(5)),
                      //   child: TextFormField(
                      //     controller: _levelController,
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter a valid level';
                      //       }
                      //       return null;
                      //     },
                      //     decoration: const InputDecoration(
                      //         contentPadding:
                      //             EdgeInsets.symmetric(horizontal: 5),
                      //         labelText: 'level',
                      //         border: InputBorder.none,
                      //         fillColor: Colors.black54,
                      //         focusColor: Colors.black54),
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child: const Text('Generate Ticket'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
