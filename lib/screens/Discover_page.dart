import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/State/EventState.dart';

import 'package:ticketmaster/providers/event_providers.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  int visibleContainerIndex1 = 0;

  void switchContainer1() {
    setState(() {
      visibleContainerIndex1 = (visibleContainerIndex1 + 1) % 4;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool iseditingCountry = false;
  final TextEditingController editingCountryController =
      TextEditingController();
  _saveText(String newText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('CountryState', newText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: const Icon(
            Icons.ac_unit,
            color: Colors.black,
          ),
          title: Row(
            children: [
              const SizedBox(
                width: 80,
              ),
              const Text(
                "ticketmaster",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 8,
              ),
              Stack(children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 0 ? 1.0 : 0.0,
                  child: Container(
                    color: const Color(0xff1f262e),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 1 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/usa-icon.png',
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 2 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/Ellipse 2.png',
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 3 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/Ellipse 3.png',
                  ),
                ),
              ]),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () {
                switchContainer1();
              },
              child: Stack(children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 0 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/usa-icon.png',
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 1 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/usa-icon.png',
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 2 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/Ellipse 2.png',
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: visibleContainerIndex1 == 3 ? 1.0 : 0.0,
                  child: myContainer(
                    image: 'assets/images/Ellipse 3.png',
                  ),
                ),
              ]),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40,
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              setState(() {
                                iseditingCountry = true;
                                editingCountryController.text =
                                    context.read<EventProvider>().countryOn;
                              });
                            },
                            child: iseditingCountry
                                ? Container(
                                    color: Colors.transparent,
                                    width: 120,
                                    child: TextField(
                                      controller: editingCountryController,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      onSubmitted: (newText) {
                                        if (newText.isNotEmpty) {
                                          _saveText(newText);
                                          context
                                              .read<EventProvider>()
                                              .getCountry();
                                          setState(() {
                                            iseditingCountry = false;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Contry cannot be empty'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                : Text(
                                    context.watch<EventProvider>().countryOn,
                                    style: TextStyle(color: Colors.white),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40,
                    color: Colors.black,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All Dates',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                  color: Colors.black,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  )),
              Container(
                color: Colors.black,
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.92,
                    height: 40,
                    color: Colors.white,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Search by Artsist, Event or Venue',
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Center(
                    child: SizedBox(
                      height: 30,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: Text(
                                'Concerts',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: Text(
                                'Sports',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: Text(
                                'Arts, Theater & Comedy',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: Text(
                                'Farmily',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.white)),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Center(
                                  child: Text(
                                'Carnivals',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Consumer<EventProvider>(builder: (context, value, child) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: (value.eventResult.state == Eventstate.isData)
                      ? value.eventResult.event.isEmpty
                          ? const BoxDecoration(color: Colors.black)
                          : BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  value.eventResult.event[0].images
                                          ?.where((element) =>
                                              element.ratio == "16_9")
                                          .first
                                          .url ??
                                      '', // Replace with your image URL
                                ),
                                fit: BoxFit
                                    .cover, // Adjust how the image fills the container
                              ),
                            )
                      : const BoxDecoration(color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Text(
                          'Eagles Live at Sphere',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(5)),
                              height: 40,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Center(
                                    child: Text(
                                  'Find Tickets',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<EventProvider>(builder: (context, value, child) {
                      if (value.eventResult.state == Eventstate.isData) {
                        if (value.eventResult.event.isEmpty) {
                          return const SizedBox();
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.eventResult.event.length,
                          itemBuilder: (context, index) {
                            return columnContainer(
                                context: context,
                                color: Colors.deepOrange,
                                imageUrl: value.eventResult.event[index].images
                                    ?.where(
                                        (element) => element.ratio == "16_9")
                                    .first
                                    .url,
                                text: value.eventResult.event[index].name,
                                subText: value.eventResult.event[index].embedded
                                        ?.venues?.first.name ??
                                    '');
                          },
                        );
                      } else if (value.eventResult.state ==
                          Eventstate.isError) {
                        return GestureDetector(
                          onTap: () {
                            context.read<EventProvider>().getMajorEvents();
                          },
                          child: const Center(
                            child: Text('Something went wrong '),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                    // columnContainer(
                    //     context: context,
                    //     color: Colors.deepOrange,
                    //     text: 'Meet Him as a VIP',
                    //     subText: 'Christian Nodal'),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // columnContainer(
                    //     context: context,
                    //     color: Colors.black,
                    //     text: 'Roll up in style as a VIP',
                    //     subText: 'Kylie Minogue'),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // columnContainer(
                    //     context: context,
                    //     color: Colors.blue,
                    //     text: 'Get Falconss ticket in a snap',
                    //     subText: 'NFL Tickets'),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // columnContainer(
                    //     context: context,
                    //     color: Colors.indigo,
                    //     text: 'Get Your Tickets Today',
                    //     subText: 'Cyndi Lauper'),
                    const SizedBox(
                      height: 40,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'POPULAR NEAR YOU',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Concerts',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Consumer<EventProvider>(builder: (context, value, child) {
                      if (value.eventResultConcert.state == Eventstate.isData) {
                        return columnContainer(
                            context: context,
                            color: Colors.yellow,
                            imageUrl: value
                                .eventResultConcert.event.first.images
                                ?.where((element) => element.ratio == "16_9")
                                .toList()[0]
                                .url,
                            text: value.eventResultConcert.event.first.name,
                            subText: value.eventResultConcert.event.first
                                    .embedded?.venues?.first.name ??
                                '');
                      } else if (value.eventResultConcert.state ==
                          Eventstate.isError) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<EventProvider>()
                                .getMajorEventsConcert();
                          },
                          child: const Center(
                            child: Text('Something went wrong '),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sports',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Consumer<EventProvider>(builder: (context, value, child) {
                      if (value.eventResultSport.state == Eventstate.isData) {
                        return columnContainer(
                            context: context,
                            color: Colors.yellow,
                            imageUrl: value.eventResultSport.event.first.images
                                ?.where((element) => element.ratio == "16_9")
                                .first
                                .url,
                            text: value.eventResultSport.event.first.name,
                            subText: value.eventResultSport.event.first.embedded
                                    ?.venues?.first.name ??
                                '');
                      } else if (value.eventResultSport.state ==
                          Eventstate.isError) {
                        return GestureDetector(
                          onTap: () {
                            context.read<EventProvider>().getMajorEventsSport();
                          },
                          child: const Center(
                            child: Text('Something went wrong '),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Arts, Theater & Comedy',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Consumer<EventProvider>(builder: (context, value, child) {
                      if (value.eventResultComedy.state == Eventstate.isData) {
                        return columnContainer(
                            context: context,
                            color: Colors.yellow,
                            imageUrl: value.eventResultComedy.event.first.images
                                ?.where((element) => element.ratio == "16_9")
                                .first
                                .url,
                            text: value.eventResultComedy.event.first.name,
                            subText: value.eventResultComedy.event.first
                                    .embedded?.venues?.first.name ??
                                '');
                      } else if (value.eventResultComedy.state ==
                          Eventstate.isError) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<EventProvider>()
                                .getMajorEventsComedy();
                          },
                          child: const Center(
                            child: Text('Something went wrong '),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Family',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                        Text(
                          'See All',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Consumer<EventProvider>(builder: (context, value, child) {
                      if (value.eventResultFamily.state == Eventstate.isData) {
                        return columnContainer(
                            context: context,
                            color: Colors.yellow,
                            imageUrl: value.eventResultFamily.event.first.images
                                ?.where((element) => element.ratio == "16_9")
                                .first
                                .url,
                            text: value.eventResultFamily.event.first.name,
                            subText: value.eventResultFamily.event.first
                                    .embedded?.venues?.first.name ??
                                '');
                      } else if (value.eventResultFamily.state ==
                          Eventstate.isError) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<EventProvider>()
                                .getMajorEventsFamily();
                          },
                          child: const Center(
                            child: Text('Something went wrong '),
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Column columnContainer(
      {required BuildContext context, color, text, subText, imageUrl}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 7,
              ),
              Text(
                subText,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container myContainer({
    required String image,
  }) {
    return Container(
      child: Container(
        width: 21,
        height: 21,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                image,
              ),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
