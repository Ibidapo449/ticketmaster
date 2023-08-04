import 'package:flutter/material.dart';
import 'package:ticketmaster/event_details.dart';
import 'package:ticketmaster/ticket_generator_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.ac_unit,
          color: Colors.black,
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Events"),
              GestureDetector(
               onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TicketGeneratorForm(),
                ));
              },
                child: const Text("Help"),
                ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 13, right: 10, left: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const EventDetails(),
                ));
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSs6uOkARyMvSA4MJUzIa-8KnWZeDn_VT4Zcg&usqp=CAU', // Replace with your image URL
                ),
              ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.025,
                      color: Colors.transparent,
                      child: const Center(
                          child: Text(
                        "NEW DATE",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.transparent,
                            fontWeight: FontWeight.w500),
                      )),
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.0, 1.0],
                        begin: FractionalOffset.topCenter,
                        end: FractionalOffset.bottomCenter,
                      )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "The Eras Tour",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              "Sun, Aug 5, 6:30pm. SoFi Stadium",
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 13,
                                  height: 13,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                          'assets/images/ticket.png',
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                const  SizedBox(width: 5,),
                                const Text(
                                  "2 tickets",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
