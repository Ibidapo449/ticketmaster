import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/EventInfo.dart';
import 'package:ticketmaster/providers/TimerProvider.dart';
import 'package:ticketmaster/providers/colorProvider.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/barcode_screen.dart';
import 'package:ticketmaster/screens/ticket_details_screen.dart';

/// Widget displaying ticket details below banner
class TicketInfoSection extends StatefulWidget {
  final EventInfo event;

  const TicketInfoSection({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<TicketInfoSection> createState() => _TicketInfoSectionState();
}

class _TicketInfoSectionState extends State<TicketInfoSection> {
  bool changeticketcount = true;
  String claimedByName = 'JORDAN BIRON';
  int ticketCount = 2;
  bool isEditingName = false;
  bool isEditingCount = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getTicketCountTitle();
      loadTicketInfo();

      final timerProvider = Provider.of<TimerProvider>(context, listen: false);
      await timerProvider.loadCountdown();

      if (timerProvider.remainingTime <= Duration.zero) {
        final pref = await SharedPreferences.getInstance();
        final endTime = DateTime.now()
            .add(const Duration(minutes: 5))
            .millisecondsSinceEpoch;
        await pref.setInt('countdownEndTime', endTime);
        await timerProvider.loadCountdown();
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    countController.dispose();
    super.dispose();
  }

  void getTicketCountTitle() async {
    final pref = await SharedPreferences.getInstance();
    changeticketcount = pref.getBool("getcountEvent") ?? false;
    setState(() {});
  }

  void loadTicketInfo() async {
    final pref = await SharedPreferences.getInstance();
    claimedByName = pref.getString('claimedByName') ?? 'JORDAN BIRON';
    ticketCount = pref.getInt('ticketCount') ?? 2;
    nameController.text = claimedByName;
    countController.text = ticketCount.toString();
    setState(() {});
  }

  void saveTicketInfo() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('claimedByName', claimedByName);
    await pref.setInt('ticketCount', ticketCount);
  }

  void saveTicketCountTitle(bool event) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool("getcountEvent", event);
    getTicketCountTitle();
  }

  Widget buildTimeCard(int time, String label) {
    return Column(
      children: [
        Text(
          time.toString().padLeft(2, '0'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    final visibleContainerIndex =
        context.watch<EventProvider>().visibleContainerIndex;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              context.read<EventProvider>().changeTicketInfo();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (visibleContainerIndex == 7)
                  buildCountdownContainer(
                      context.watch<TimerProvider>().remainingTime),
                if (visibleContainerIndex == 6)
                  buildAppleWalletContainer(colorProv),
                if (visibleContainerIndex == 1)
                  buildViewInWalletContainer(colorProv),
                if (visibleContainerIndex == 2)
                  buildSmartIconContainer(colorProv),
                if (visibleContainerIndex == 3)
                  buildNotReadyContainer(colorProv),
                if (visibleContainerIndex == 4)
                  ticketClaimedContainer(colorProv),
                // if (visibleContainerIndex == 5)
                //   ticketSentContainer(colorProv),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCountdownContainer(Duration countdown) => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    changeticketcount = !changeticketcount;
                  });
                  saveTicketCountTitle(changeticketcount);
                },
                child: Text(
                  changeticketcount
                      ? 'The event will start in'
                      : 'Ticket will be ready in',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _timeCard(countdown.inDays, 'DAY'),
                  const SizedBox(width: 16),
                  _timeCard(countdown.inHours % 24, 'HOUR'),
                  const SizedBox(width: 16),
                  _timeCard(countdown.inMinutes % 60, 'MIN'),
                  const SizedBox(width: 16),
                  _timeCard(countdown.inSeconds % 60, 'SEC'),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TicketDetails(),
                  ));
                },
                child: const Text(
                  "Ticket Details",
                  style: TextStyle(
                      color: Color.fromARGB(255, 51, 90, 135),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _timeCard(int time, String label) => Column(
        children: [
          Text(
            '$time',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 1.5, vertical: 1),
              child: Text(label, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      );

  Widget buildAppleWalletContainer(ColorProvider colorProv) => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              widget.event.level,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/applewallet.png",
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 15),
                      const Text(
                        "Add to Apple Wallet",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BarcodeScreen(event: widget.event),
                      ));
                    },
                    child: const Text(
                      "View Barcode",
                      style: TextStyle(
                          color: Color.fromARGB(255, 51, 90, 135),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TicketDetails(),
                      ));
                    },
                    child: const Text(
                      "Ticket Details",
                      style: TextStyle(
                          color: Color.fromARGB(255, 51, 90, 135),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildViewInWalletContainer(ColorProvider colorProv) => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Text(
                widget.event.level,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 40),
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                    color: colorProv.currentColor,
                    borderRadius: BorderRadius.circular(2)),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 26,
                          width: 26,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(13)),
                          child: const Icon(
                            Icons.check,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 15),
                        const FittedBox(
                          child: Text(
                            "View in wallet",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              BarcodeScreen(event: widget.event),
                        ));
                      },
                      child: const Text(
                        "View Barcode",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 90, 135),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TicketDetails(),
                        ));
                      },
                      child: const Text(
                        "Ticket Details",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 90, 135),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildSmartIconContainer(ColorProvider colorProv) => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(
                // color: Colors.red,
                child: Column(
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset(
                          "assets/images/verified.png",
                          color: Colors.black,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Your tickets aren't quite ready yet.",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Please check back later",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 30,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BarcodeScreen(
                            event: widget.event,
                          ),
                        ));
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "View Barcode",
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 90, 135),
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const TicketDetails(),
                          ));
                        },
                        child: const Text(
                          "Ticket Details",
                          style: TextStyle(
                              color: Color.fromARGB(255, 51, 90, 135),
                              fontSize: 13,
                              fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildNotReadyContainer(ColorProvider colorProv) => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.event.level,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BarcodeScreen(
                      event: widget.event,
                    ),
                  ));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.75,
                  decoration: BoxDecoration(
                      color: !colorProv.isPrimary
                          ? colorProv.currentColor
                          : const Color(0xff004ee9),
                      borderRadius: BorderRadius.circular(1)),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 17,
                              width: 30,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                  'assets/images/smarticon.png',
                                )),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        const FittedBox(
                          child: Text(
                            "View Ticket",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 236, 236, 236)),
                          ),
                        ),
                      ],
                    ),
                  )),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            BarcodeScreen(event: widget.event),
                      ));
                    },
                    child: const Text(
                      "View Barcode",
                      style: TextStyle(
                          color: Color.fromARGB(255, 51, 90, 135),
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const TicketDetails(),
                        ));
                      },
                      child: const Text(
                        "Ticket Details",
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 90, 135),
                            fontSize: 13,
                            fontWeight: FontWeight.w600),
                      ))
                ],
              )
            ],
          ),
        ),
      );

  Widget ticketClaimedContainer(ColorProvider colorProv) => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              widget.event.level,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BarcodeScreen(event: widget.event),
                ));
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(1)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 17,
                            width: 30,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                'assets/images/smarticon.png',
                              )),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const FittedBox(
                        child: Text(
                          "View Ticket",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 236, 236, 236)),
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const TicketDetails(),
                      ));
                    },
                    child: const Text(
                      "Ticket Details",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ))
              ],
            )
          ],
        ),
      );
}
