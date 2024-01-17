// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:firebase_core/firebase_core.dart';
// Import the provider class you created

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _artistNameController = TextEditingController();
  TextEditingController artistNameController = TextEditingController();
  TextEditingController eventNameController =
      TextEditingController(text: FormDataProvider().formData.eventName);
  TextEditingController sectionController = TextEditingController();
  TextEditingController rowController = TextEditingController();
  TextEditingController seatController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController ticketTypeController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController numberOfTicketsController = TextEditingController();
  void _submitForm(BuildContext context) async {
    await Firebase.initializeApp();
    if (_formKey.currentState!.validate()) {
      // Form is valid, update form data using the provider
      SmartDialog.showLoading();
      FormData newFormData = FormData(
        artistName: artistNameController.text,
        eventName: eventNameController.text,
        section: sectionController.text,
        row: rowController.text,
        seat: seatController.text.isEmpty ? '1' : seatController.text,
        date: dateController.text,
        location: locationController.text,
        time: timeController.text,
        ticketType: ticketTypeController.text,
        level: levelController.text,
        numberOfTicket: int.parse(numberOfTicketsController.text.isEmpty
            ? '1'
            : numberOfTicketsController.text),
        // email: _emailController.text,
      );

      await context
          .read<EventProvider>()
          .getAllEvents(eventNameController.text, artistNameController.text);
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
        await writeData(
            newFormData.artistName,
            newFormData.eventName,
            newFormData.section,
            newFormData.row,
            newFormData.seat,
            newFormData.date,
            newFormData.location,
            newFormData.time,
            newFormData.ticketType,
            newFormData.level,
            newFormData.numberOfTicket,
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
  void initState() {
    // TODO: implement initState
    super.initState();
    final FormDataget = Provider.of<FormDataProvider>(context, listen: false);

    artistNameController =
        TextEditingController(text: FormDataget.formData.artistName);
    eventNameController =
        TextEditingController(text: FormDataget.formData.eventName);
    sectionController =
        TextEditingController(text: FormDataget.formData.section);
    rowController = TextEditingController(text: FormDataget.formData.row);
    seatController = TextEditingController(text: FormDataget.formData.seat);
    dateController = TextEditingController(text: FormDataget.formData.date);
    locationController =
        TextEditingController(text: FormDataget.formData.location);
    timeController = TextEditingController(text: FormDataget.formData.time);
    ticketTypeController =
        TextEditingController(text: FormDataget.formData.ticketType);
    levelController = TextEditingController(text: FormDataget.formData.level);
    numberOfTicketsController = TextEditingController(
        text: FormDataget.formData.numberOfTicket.toString());

    print(context.read<FormDataProvider>().formData.artistName);
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
                          controller: artistNameController,
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
                          controller: eventNameController,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter a valid event name';
                          //   }
                          //   return null;
                          // },
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
                          controller: sectionController,
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
                          controller: rowController,
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
                          controller: seatController,
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
                          controller: dateController,
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
                          controller: locationController,
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
                          controller: timeController,
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
                          controller: ticketTypeController,
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
                          controller: levelController,
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
                          controller: numberOfTicketsController,
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

  writeData(artistname, eventname, section, row, seat, date, location, time,
      ticketype, level, numticket, image) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getInt('token');
    final dbref = FirebaseDatabase.instance.ref('ticket/$token');

    dbref.push().child('').set({
      'id': token,
      'artistName': artistname,
      'eventname': eventname,
      'section': section,
      'row': row,
      'seat': seat,
      'date': date,
      'location': location,
      'time': time,
      'ticketype': ticketype,
      'level': level,
      'numticket': numticket,
      'image': image
    });
  }
}
