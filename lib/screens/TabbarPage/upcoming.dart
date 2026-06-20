// ignore_for_file: unused_local_variable, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketmaster/model/event_model.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/event_detaila_screen_with_tabbar.dart';
import 'package:ticketmaster/screens/form_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class Upcoming extends StatefulWidget {
  final String searchQuery;

  const Upcoming({super.key, this.searchQuery = ''});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  int dataIndex = 0;
  bool showNextEvent = true;
  int daysUntilEvent = 0;

  void toggleEventText() {
    setState(() {
      showNextEvent = !showNextEvent;
    });
  }

  void showEditDaysDialog() {
    // implement dialog to edit days if needed
  }

  Stream<QuerySnapshot> getmessages(token) {
    final firestore = FirebaseFirestore.instance;
    return firestore
        .collection("ticket")
        .doc(token.toString())
        .collection("messages")
        .snapshots();
  }

  bool _matchesSearch(Map<String, dynamic> data, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final searchableValues = [
      data['eventName'],
      data['artistName'],
      data['location'],
      data['date'],
    ];

    return searchableValues.any(
      (value) => value.toString().toLowerCase().contains(normalizedQuery),
    );
  }

  Widget listItem({required List<QueryDocumentSnapshot> tickets, index}) {
    final data = tickets[index].data() as Map<String, dynamic>;

    return GestureDetector(
      onLongPress: () {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: 'Delete Ticket',
          desc: 'Are you sure you want to delete ticket',
          btnCancelOnPress: () {
            FormData newdata = FormData(
                artistName: data['artistName'] ?? '',
                eventName: data['eventName'] ?? '',
                section: data['section'] ?? '',
                row: data['row'] ?? '',
                seat: data['seat'] ?? '',
                date: data['date'] ?? '',
                address: data['address'] ?? '',
                location: data['location'] ?? '',
                time: data['time'] ?? '',
                ticketType: data['ticketType'] ?? '',
                level: data['level'] ?? '',
                numberOfTicket: data['numberOfTicket'] ?? 1,
                imageUrl: data['image'] ?? '');
            context.read<FormDataProvider>().updateFormData(newdata);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const FormScreen(),
            ));
          },
          btnOkOnPress: () async {
            final eventprovider =
                Provider.of<EventProvider>(context, listen: false);
            final firestore = FirebaseFirestore.instance;
            List<Map> items = tickets.map((e) => {'id': e.id}).toList();

            await firestore
                .collection("ticket")
                .doc(eventprovider.token.toString())
                .collection('messages')
                .doc(items[index]['id'])
                .delete();
          },
        ).show();
      },
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventDetailaScreenWithTabbar(
                artistName: data['artistName'] ?? '',
                eventName: data['eventName'] ?? '',
                section: data['section'] ?? '',
                row: data['row'] ?? '',
                seat: data['seat'] ?? '',
                date: data['date'] ?? '',
                location: data['location'] ?? '',
                address: data['address'] ?? '',
                time: data['time'] ?? '',
                image: data['image'] ?? '',
                ticketType: data['ticketType'] ?? '',
                level: data['level'] ?? '',
                number_of_ticket: data['numberOfTicket'] ?? 1)));
      },
      child: _buildEventCard(tickets, index),
    );
  }

  Widget _buildEventCard(List<QueryDocumentSnapshot> tickets, int index) {
    final ticket = tickets[index];
    const panelColor = Color(0xFF232323);
    final eventTitle = ticket['eventName'] == ''
        ? ticket['artistName'].toString().toUpperCase()
        : ticket['eventName'].toString().toUpperCase();

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 10, 14, 18),
      child: ClipRRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.64,
                  child: Image.network(
                    ticket['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.black45,
                          size: 36,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Container(
                    color: panelColor,
                    padding: const EdgeInsets.fromLTRB(14, 12, 18, 12),
                    child: Text(
                      '${ticket['date'].toString().toUpperCase()} • ${ticket['time']}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              color: panelColor,
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventTitle,
                    style: const TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.12,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    height: 4,
                    width: 220,
                    color: const Color(0xFF776449),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ticket['location'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.92),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventprovider = context.watch<EventProvider>();
    dataIndex = 0;
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: getmessages(eventprovider.token),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!eventprovider.loaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                eventprovider.getlength1(snapshot.data?.docs.length ?? 0);
                eventprovider.updateLoaded(true);
              });
            }
            if (snapshot.data?.docs.isEmpty ?? true) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Text("No event added yet !")),
                ),
              );
            } else {
              final sortedDocs = snapshot.data!.docs.toList()
                ..sort((a, b) => a['artistName']
                    .toString()
                    .toLowerCase()
                    .compareTo(b['artistName'].toString().toLowerCase()));
              final filteredDocs = sortedDocs
                  .where((doc) => _matchesSearch(
                      doc.data() as Map<String, dynamic>, widget.searchQuery))
                  .toList();

              if (filteredDocs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Text(
                        'No events match "${widget.searchQuery.trim()}"',
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shrinkWrap: true,
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  return listItem(tickets: filteredDocs, index: index);
                },
              );
            }
          },
        ));
  }
}
