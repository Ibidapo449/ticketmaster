import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/providers/colorProvider.dart';
import 'package:ticketmaster/screens/my_tickets.dart';
import 'package:ticketmaster/screens/widgets/ticket_pending_modal.dart';
import 'package:ticketmaster/screens/widgets/ticket_successful_modal.dart';

import '../../model/EventInfo.dart' show EventInfo;

/// Stateful bottom sheet handling transfer flow
class TransferBottomSheet extends StatefulWidget {
  final EventInfo event;
  const TransferBottomSheet({Key? key, required this.event}) : super(key: key);

  @override
  State<TransferBottomSheet> createState() => _TransferBottomSheetState();
}

class _TransferBottomSheetState extends State<TransferBottomSheet> {
  int _stage = 1;
  late final List<bool> _checkboxStates;
  late final TextEditingController _ticketController;
  late final TextEditingController _seatController;

  bool _isEditingNumberOfTicketSelected = false;
  final TextEditingController _numberOfTicketSelectedEditingController =
      TextEditingController();

  bool _isEditingSeat = false;
  final TextEditingController _seatEditingController = TextEditingController();

  String _numberOfTicketSelected = '2 Ticket Selected';
  String _seat = '15, 16, 17, 18';
  bool _isDoubleTap = false;
  @override
  void initState() {
    super.initState();
    _checkboxStates = List<bool>.filled(widget.event.ticketCount, false);
    _ticketController = TextEditingController();
    _seatController = TextEditingController();
    _loadSavedText();
  }

  @override
  void dispose() {
    _ticketController.dispose();
    _seatController.dispose();
    super.dispose();
  }

  int get _selectedCount => _checkboxStates.where((c) => c).length;

  void _nextStage() => setState(() => _stage = _stage % 3 + 1);
  void _previousStage() => setState(() => _stage = _stage > 1 ? _stage - 1 : 1);
  void _resetStage() => setState(() => _stage = 1);
  _saveText(String newText, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, newText);
  }

  _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _numberOfTicketSelected =
          prefs.getString('numberof_ticketselected') ?? _numberOfTicketSelected;
      _seat = prefs.getString('seat') ?? _seat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.63,
      child: Scaffold(
        body: SafeArea(
            child: _stage == 1
                ? _buildSeatSelection(context)
                : _stage == 2
                    ? _buildSelectManual(context)
                    : _buildManualEntry(context)),
      ),
    );
  }

  Widget _buildSeatSelection(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        const Align(
            alignment: Alignment.center,
            child: Text('SELECT TICKETS TRANSFER TICKET')),
        Divider(
          color: Colors.grey.shade200,
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 90,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black54),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Column(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          // color: Colors.black,
                          child: const FittedBox(
                            child: Text(
                              "Only transfer tickets to people you know and\ntrust to ensure everyone stays safe and\nsocially distanced.",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        "Sec ",
                        style: TextStyle(
                            color: Colors.black.withOpacity(.7), fontSize: 16),
                      ),
                      Text(
                        '${widget.event.section},',
                        style: TextStyle(
                            color: Colors.black.withOpacity(.7), fontSize: 16),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        " Row ",
                        style: TextStyle(
                            color: Colors.black.withOpacity(.7), fontSize: 16),
                      ),
                      Text(
                        widget.event.row,
                        style: TextStyle(
                            color: Colors.black.withOpacity(.7), fontSize: 16),
                      )
                    ],
                  ),
                ],
              ),
              Text(
                "${widget.event.ticketCount.toString()} Tickets",
                style: TextStyle(
                  color: Colors.black.withOpacity(.7),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 15),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 82,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.event.ticketCount,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            height: 82,
                            width: 80,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: !colorProv.isPrimary
                                          ? colorProv.currentColor
                                          : Color(0xff0361cb),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(9),
                                      )),
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Text(
                                            "SEAT ",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            widget.event.seat == '0'
                                                ? ''
                                                : widget.event.seat == '1'
                                                    ? ''
                                                    : widget.event.seat == '-'
                                                        ? widget.event.seat
                                                        : (int.parse(widget
                                                                    .event
                                                                    .seat) +
                                                                index)
                                                            .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.transparent,
                                  height: 50,
                                  child: Center(
                                    child: CustomCircleCheckbox(
                                      isChecked: _checkboxStates[index],
                                      onChanged: (v) => setState(
                                          () => _checkboxStates[index] = v!),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Divider(
          color: Colors.grey.shade300,
        ),
        const Spacer(),
        Column(
          children: [
            Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$_selectedCount Selected",
                      style: TextStyle(
                        color: Colors.black.withOpacity(.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: _selectedCount > 0 ? _nextStage : null,
                      onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Center(
                                child: Text("Please, select all tickets")),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 10),
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _selectedCount > 0 ? _nextStage : null,
                            child: Text(
                              "TRAN...ER TO",
                              style: TextStyle(
                                color: const Color(0xff0361cb).withOpacity(.8),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.grey,
                            size: 25,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSelectManual(BuildContext context) {
    return Column(
      // shrinkWrap: true,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Align(
                alignment: Alignment.center, child: Text('TRANSFER TO')),
            Divider(
              color: Colors.grey.shade200,
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff0377e2))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select From Contacts',
                        style: TextStyle(
                            color: Color(0xff0377e2),
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Image.asset(
                        'assets/images/contact.jpg',
                        height: 25,
                        width: 25,
                        fit: BoxFit.scaleDown,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    _nextStage();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .8,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xff0377e2))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Manually Enter A Recipient',
                          style: TextStyle(
                              color: Color(0xff0377e2),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        SvgPicture.asset(
                          'assets/images/add-circle.svg',
                          color: const Color(0xff0377e2),
                          height: 25,
                          width: 25,
                          fit: BoxFit.scaleDown,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
            child: Column(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(100)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SvgPicture.asset(
                  'assets/images/send-paper.svg',
                  height: 45,
                  width: 45,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            const SizedBox(
              width: 250,
              child: Text(
                'Transfer Ticket Via Email or Text Message',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 300,
              child: Text(
                'Select an Email or mobile number to transfer tickets to your recipient',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
            ),
          ],
        )),
        SizedBox(
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  _previousStage();
                },
                child: const Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff0377e2),
                    ),
                    Text(
                      "BACK",
                      style: TextStyle(
                        color: Color(0xff0377e2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildManualEntry(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        shrinkWrap: true,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
              alignment: Alignment.center, child: Text('TRANSFER TICKET')),
          const Divider(),
          GestureDetector(
            onTap: () {
              setState(() {
                _isEditingNumberOfTicketSelected = true;
                _numberOfTicketSelectedEditingController.text =
                    _numberOfTicketSelected;
              });
            },
            child: _isEditingNumberOfTicketSelected
                ? TextField(
                    controller: _numberOfTicketSelectedEditingController,
                    style: const TextStyle(color: Colors.grey),
                    onSubmitted: (newText) {
                      if (newText.isNotEmpty) {
                        _saveText(newText, 'numberof_ticketselected');

                        setState(() {
                          _numberOfTicketSelected = newText;
                          _isEditingNumberOfTicketSelected = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ticket Price cannot be empty'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  )
                : Text(
                    _numberOfTicketSelected,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Row(
                children: [
                  Text(
                    "Sec ",
                    style: TextStyle(color: Colors.black.withOpacity(.4)),
                  ),
                  Text(
                    '${widget.event.section} ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditingSeat = true;
                    _seatEditingController.text = _seat;
                  });
                },
                child: Row(
                  children: [
                    Text(
                      "Row ",
                      style: TextStyle(color: Colors.black.withOpacity(.4)),
                    ),
                    Text(
                      '${widget.event.row} ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  _isEditingSeat
                      ? Container(
                          color: Colors.transparent,
                          width: 180,
                          child: TextField(
                            controller: _seatEditingController,
                            style: const TextStyle(color: Colors.grey),
                            onSubmitted: (newText) {
                              if (newText.isNotEmpty) {
                                _saveText(newText, 'seat');

                                setState(() {
                                  _seat = newText;
                                  _isEditingSeat = false;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Seat cannot be empty'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                          ),
                        )
                      : _seat != '1'
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isEditingSeat = true;
                                  _seatEditingController.text = _seat;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Seat ",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.4)),
                                  ),
                                  _seat != '0'
                                      ? Text(
                                          _seat,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            )
                          : const SizedBox()
                ],
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          const Text("First Name"),
          transferTicketContainer(context, text: "First Name", height: 40.0),
          const SizedBox(
            height: 15,
          ),
          const Text("Last Name"),
          const SizedBox(
            height: 3,
          ),
          transferTicketContainer(context, text: "Last Name", height: 40.0),
          const SizedBox(
            height: 15,
          ),
          const Text("Email or Mobile Number"),
          const SizedBox(
            height: 3,
          ),
          transferTicketContainer(context,
              text: "Email or Mobile Number", height: 40.0),
          const SizedBox(
            height: 15,
          ),
          const Text("Note"),
          const SizedBox(
            height: 3,
          ),
          Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
              )),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _resetStage();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_left,
                      color: colorProv.currentColor,
                    ),
                    Text(
                      "BACK",
                      style: TextStyle(
                        color: colorProv.currentColor,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Timer(const Duration(milliseconds: 300), () {
                    if (!_isDoubleTap) {
                      Navigator.of(context).pop();
                      AwesomeDialog(
                        context: context,
                        headerAnimationLoop: false,
                        animType: AnimType.bottomSlide,
                        dialogType: DialogType.noHeader,
                        body: const TicketTransferSuccessfullModal(),
                      ).show();
                    }
                  });
                },
                onDoubleTap: () {
                  _isDoubleTap = true;
                  Navigator.of(context).pop();
                  AwesomeDialog(
                    context: context,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    dialogType: DialogType.noHeader,
                    body: const TicketTransferPendinglModal(),
                  ).show();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _isDoubleTap = false; // Reset the flag after the delay
                  });
                },
                child: Container(
                  height: 40,
                  width: 210,
                  decoration: BoxDecoration(
                    color: colorProv.currentColor,
                  ),
                  child: Center(
                      child: Text(
                    widget.event.ticketCount == 1
                        ? "Transfer Ticket"
                        : "Transfer Tickets",
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
