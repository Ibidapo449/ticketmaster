import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketDetails extends StatefulWidget {
  const TicketDetails({super.key});

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails> {
  String _seatLocation = 'LAWN30 / GA3 / -';
  String _entryInfo = 'ALLENGIANT LAWN';
  String _orderNumber = '55036484';
  String _ticketType = 'Seated Ticket - Side view';
  String _purchaseDate = 'Sun, Jan 15 2023 - view';
  String _dateOfTheTour = 'Tue, Jul 18, 6:30pm. Blossom Music Center';
  String _nameOfTheTour = 'Fall Out Boy - So Much For (Tour) Dust';
  String _nameOfEventCenter = 'Blossom Music Center';
  String _addressOfEventCenter = 'Cuyahoga Falls OH US';
  String _ticketPrice = '\$16.35';
  String _ticketFee = '\$16.35';
  String _ticketTax = '\$16.35';
  String _ticketInfo1 = "LIVE NATION PRESENTS";
  String _ticketInfo2 = "FALL OUT BOY";
  String _ticketInfo3 = "SO MUCH FOR (TOUR) DUST";
  String _ticketInfo4 = "BLOSSOM MUSIC CAREER";
  String _ticketInfo5 = "RAIN OR SHINE EVENT";
  String _ticketInfo6 = "TUE JUL 18 2023 6:30 PM";
  String _ticketGrandTotal = '\$16.35';
  String _ticketName = 'Take A Seat Bundle(Lawn Ticket + Lawn Chair)';

  bool _isEditingSeatLocation = false;
  bool _isEditingEntryInfo = false;
  bool _isEditingOrderNumber = false;
  bool _isEditingTicketType = false;
  bool _isEditingPurchaseDate = false;
  bool _isEditingDateOfTheTour = false;
  bool _isEditingNameOfTheTour = false;
  bool _isEditingNameOfEventCenter = false;
  bool _isEditingAddressOfEventCenter = false;
  bool _isEditingTicketPrice = false;
  bool _isEditingTicketFee = false;
  bool _isEditingTicketTax = false;
  bool _isEditingTicketInfo = false;
  bool _isEditingTicketInfo2 = false;
  bool _isEditingTicketInfo3 = false;
  bool _isEditingTicketInfo4 = false;
  bool _isEditingTicketInfo5 = false;
  bool _isEditingTicketInfo6 = false;

  bool _isEditingTicketGrandTotal = false;
  bool _isEditingTicketName = false;

  final TextEditingController _seatLocationEditingController =
      TextEditingController();
  final TextEditingController _entryInfoEditingController =
      TextEditingController();
  final TextEditingController _orderNumberEditingController =
      TextEditingController();
  final TextEditingController _ticketTypeEditingController =
      TextEditingController();
  final TextEditingController _purchaseDateEditingController =
      TextEditingController();
  final TextEditingController _dateOfTheTourEditingController =
      TextEditingController();
  final TextEditingController _nameOfTheTourEditingController =
      TextEditingController();
  final TextEditingController _nameOfEventCenterEditingController =
      TextEditingController();
  final TextEditingController _addressOfEventCenterEditingController =
      TextEditingController();
  final TextEditingController _ticketPriceEditingController =
      TextEditingController();
  final TextEditingController _ticketFeeEditingController =
      TextEditingController();
  final TextEditingController _ticketTaxEditingController =
      TextEditingController();
  final TextEditingController _ticketInfo1EditingController =
      TextEditingController();
  final TextEditingController _ticketInfo2EditingController =
      TextEditingController();
  final TextEditingController _ticketInfo3EditingController =
      TextEditingController();
  final TextEditingController _ticketInfo4EditingController =
      TextEditingController();
  final TextEditingController _ticketInfo5EditingController =
      TextEditingController();
  final TextEditingController _ticketInfo6EditingController =
      TextEditingController();

  final TextEditingController _ticketGrandTotalEditingController =
      TextEditingController();
  final TextEditingController _ticketNameEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedText();
  }

  _loadSavedText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _seatLocation = prefs.getString('seat_location') ?? _seatLocation;
      _entryInfo = prefs.getString('entry_info') ?? _entryInfo;
      _orderNumber = prefs.getString('order_number') ?? _orderNumber;
      _ticketType = prefs.getString('ticket_type') ?? _ticketType;
      _purchaseDate = prefs.getString('purchase_date') ?? _purchaseDate;
      _dateOfTheTour = prefs.getString('dateof_thetour') ?? _dateOfTheTour;
      _nameOfTheTour = prefs.getString('nameof_thetour') ?? _nameOfTheTour;
      _nameOfEventCenter =
          prefs.getString('nameof_eventcenter') ?? _nameOfEventCenter;
      _addressOfEventCenter =
          prefs.getString('addressof_eventcenter') ?? _addressOfEventCenter;
      _ticketPrice = prefs.getString('ticket_price') ?? _ticketPrice;
      _ticketFee = prefs.getString('ticket_fee') ?? _ticketFee;
      _ticketTax = prefs.getString('ticket_tax') ?? _ticketTax;
      _ticketInfo1 = prefs.getString('ticket_info1') ?? _ticketInfo1;
      _ticketInfo2 = prefs.getString('ticket_info2') ?? _ticketInfo2;
      _ticketInfo3 = prefs.getString('ticket_info3') ?? _ticketInfo3;
      _ticketInfo4 = prefs.getString('ticket_info4') ?? _ticketInfo4;
      _ticketInfo5 = prefs.getString('ticket_info5') ?? _ticketInfo5;
      _ticketInfo6 = prefs.getString('ticket_info6') ?? _ticketInfo6;
      _ticketGrandTotal =
          prefs.getString('ticket_grandtotal') ?? _ticketGrandTotal;
      _ticketName = prefs.getString('ticket_name') ?? _ticketName;
    });
  }

  _saveText(String newText, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, newText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: const EdgeInsets.all(17.0),
          child: GestureDetector(
            onTap: Navigator.of(context).pop,
            child: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(
                "assets/images/cancel.png",
                color: Colors.white,
              ),
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(left: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ticket Details",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                "Help",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              myColumn(
                text: "Seat Location",
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingSeatLocation = true;
                    _seatLocationEditingController.text = _seatLocation;
                  });
                },
                child: _isEditingSeatLocation
                    ? TextField(
                        controller: _seatLocationEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'seat_location');
                            setState(() {
                              _seatLocation = newText;
                              _isEditingSeatLocation = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Seat number cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _seatLocation,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingNameOfTheTour = true;
                    _nameOfTheTourEditingController.text = _nameOfTheTour;
                  });
                },
                child: _isEditingNameOfTheTour
                    ? TextField(
                        controller: _nameOfTheTourEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'nameof_thetour');
                            setState(() {
                              _nameOfTheTour = newText;
                              _isEditingNameOfTheTour = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Name of the tour cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _nameOfTheTour,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingDateOfTheTour = true;
                    _dateOfTheTourEditingController.text = _dateOfTheTour;
                  });
                },
                child: _isEditingDateOfTheTour
                    ? TextField(
                        controller: _dateOfTheTourEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'dateof_thetour');
                            setState(() {
                              _dateOfTheTour = newText;
                              _isEditingDateOfTheTour = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Date of the tour cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _dateOfTheTour,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(
                text: "Entry Info",
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingEntryInfo = true;
                    _entryInfoEditingController.text = _entryInfo;
                    _ticketInfo1EditingController.text = _ticketInfo1;
                    _ticketInfo2EditingController.text = _ticketInfo2;
                    _ticketInfo3EditingController.text = _ticketInfo3;
                    _ticketInfo4EditingController.text = _ticketInfo4;
                    _ticketInfo5EditingController.text = _ticketInfo5;
                    _ticketInfo6EditingController.text = _ticketInfo6;
                  });
                },
                child: _isEditingEntryInfo
                    ? TextField(
                        controller: _entryInfoEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'entry_info');
                            setState(() {
                              _entryInfo = newText;
                              _isEditingEntryInfo = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Entry Info cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _entryInfo,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ticket Info",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _isEditingTicketInfo = true;
                        _entryInfoEditingController.text = _entryInfo;
                        _ticketInfo1EditingController.text = _ticketInfo1;
                        _ticketInfo2EditingController.text = _ticketInfo2;
                        _ticketInfo3EditingController.text = _ticketInfo3;
                        _ticketInfo4EditingController.text = _ticketInfo4;
                        _ticketInfo5EditingController.text = _ticketInfo5;
                        _ticketInfo6EditingController.text = _ticketInfo6;
                      });
                    },
                    child: _isEditingTicketInfo
                        ? SizedBox(
                            width: 280,
                            child: TextField(
                              controller: _ticketInfo1EditingController,
                              style: const TextStyle(color: Colors.grey),
                              onSubmitted: (newText) {
                                if (newText.isNotEmpty) {
                                  _saveText(newText, 'ticket_info1');
                                  setState(() {
                                    _ticketInfo1 = newText;
                                    _isEditingTicketInfo = false;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Ticket Tax cannot be empty'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        : Text(
                            _ticketInfo1,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  GestureDetector(
                    onLongPress: () {
                      setState(() {
                        _isEditingTicketInfo = true;
                        _entryInfoEditingController.text = _entryInfo;
                        _ticketInfo1EditingController.text = _ticketInfo1;
                        _ticketInfo2EditingController.text = _ticketInfo2;
                        _ticketInfo3EditingController.text = _ticketInfo3;
                        _ticketInfo4EditingController.text = _ticketInfo4;
                        _ticketInfo5EditingController.text = _ticketInfo5;
                        _ticketInfo6EditingController.text = _ticketInfo6;
                      });
                    },
                    child: _isEditingTicketInfo
                        ? SizedBox(
                            width: 280,
                            child: TextField(
                              controller: _ticketInfo2EditingController,
                              style: const TextStyle(color: Colors.grey),
                              onSubmitted: (newText) {
                                if (newText.isNotEmpty) {
                                  _saveText(newText, 'ticket_info2');
                                  setState(() {
                                    _ticketInfo2 = newText;
                                    _isEditingTicketInfo = false;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Ticket Tax cannot be empty'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                            ),
                          )
                        : Text(
                            _ticketInfo2,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                  ),
                  _ticketInfo3 != '' || _isEditingTicketInfo
                      ? GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _isEditingTicketInfo = true;
                              _entryInfoEditingController.text = _entryInfo;
                              _ticketInfo1EditingController.text = _ticketInfo1;
                              _ticketInfo2EditingController.text = _ticketInfo2;
                              _ticketInfo3EditingController.text = _ticketInfo3;
                              _ticketInfo4EditingController.text = _ticketInfo4;
                              _ticketInfo5EditingController.text = _ticketInfo5;
                              _ticketInfo6EditingController.text = _ticketInfo6;
                            });
                          },
                          child: _isEditingTicketInfo
                              ? SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: _ticketInfo3EditingController,
                                    style: const TextStyle(color: Colors.grey),
                                    onSubmitted: (newText) {
                                      if (newText.isNotEmpty) {
                                        _saveText(newText, 'ticket_info3');
                                        setState(() {
                                          _ticketInfo3 = newText;
                                          _isEditingTicketInfo = false;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Ticket Tax cannot be empty'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              : Text(
                                  _ticketInfo3,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                        )
                      : const SizedBox(),
                  _ticketInfo4 != '' || _isEditingTicketInfo
                      ? GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _isEditingTicketInfo = true;
                              _entryInfoEditingController.text = _entryInfo;
                              _ticketInfo1EditingController.text = _ticketInfo1;
                              _ticketInfo2EditingController.text = _ticketInfo2;
                              _ticketInfo3EditingController.text = _ticketInfo3;
                              _ticketInfo4EditingController.text = _ticketInfo4;
                              _ticketInfo5EditingController.text = _ticketInfo5;
                              _ticketInfo6EditingController.text = _ticketInfo6;
                            });
                          },
                          child: _isEditingTicketInfo
                              ? SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: _ticketInfo4EditingController,
                                    style: const TextStyle(color: Colors.grey),
                                    onSubmitted: (newText) {
                                      if (newText.isNotEmpty) {
                                        _saveText(newText, 'ticket_info4');
                                        setState(() {
                                          _ticketInfo4 = newText;
                                          _isEditingTicketInfo = false;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Ticket Tax cannot be empty'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              : Text(
                                  _ticketInfo4,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                        )
                      : SizedBox(),
                  _ticketInfo5 != '' || _isEditingTicketInfo
                      ? GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _isEditingTicketInfo = true;
                              _entryInfoEditingController.text = _entryInfo;
                              _ticketInfo1EditingController.text = _ticketInfo1;
                              _ticketInfo2EditingController.text = _ticketInfo2;
                              _ticketInfo3EditingController.text = _ticketInfo3;
                              _ticketInfo4EditingController.text = _ticketInfo4;
                              _ticketInfo5EditingController.text = _ticketInfo5;
                              _ticketInfo6EditingController.text = _ticketInfo6;
                            });
                          },
                          child: _isEditingTicketInfo
                              ? SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: _ticketInfo5EditingController,
                                    style: const TextStyle(color: Colors.grey),
                                    onSubmitted: (newText) {
                                      _saveText(newText, 'ticket_info5');
                                      setState(() {
                                        _ticketInfo5 = newText;
                                        _isEditingTicketInfo = false;
                                      });
                                    },
                                  ),
                                )
                              : Text(
                                  _ticketInfo5,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                        )
                      : SizedBox(),
                  _ticketInfo6 != '' || _isEditingTicketInfo
                      ? GestureDetector(
                          onLongPress: () {
                            setState(() {
                              _isEditingTicketInfo = true;
                              _entryInfoEditingController.text = _entryInfo;
                              _ticketInfo1EditingController.text = _ticketInfo1;
                              _ticketInfo2EditingController.text = _ticketInfo2;
                              _ticketInfo3EditingController.text = _ticketInfo3;
                              _ticketInfo4EditingController.text = _ticketInfo4;
                              _ticketInfo5EditingController.text = _ticketInfo5;
                              _ticketInfo6EditingController.text = _ticketInfo6;
                            });
                          },
                          child: _isEditingTicketInfo
                              ? SizedBox(
                                  width: 280,
                                  child: TextField(
                                    controller: _ticketInfo6EditingController,
                                    style: const TextStyle(color: Colors.grey),
                                    onSubmitted: (newText) {
                                      _saveText(newText, 'ticket_info6');
                                      setState(() {
                                        _ticketInfo6 = newText;
                                        _isEditingTicketInfo = false;
                                      });
                                    },
                                  ),
                                )
                              : Text(
                                  _ticketInfo6,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                        )
                      : SizedBox()
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingNameOfEventCenter = true;
                    _nameOfEventCenterEditingController.text =
                        _nameOfEventCenter;
                  });
                },
                child: _isEditingNameOfEventCenter
                    ? TextField(
                        controller: _nameOfEventCenterEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'nameof_eventcenter');
                            setState(() {
                              _nameOfEventCenter = newText;
                              _isEditingNameOfEventCenter = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Name of the Event Center cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _nameOfEventCenter,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingAddressOfEventCenter = true;
                    _addressOfEventCenterEditingController.text =
                        _addressOfEventCenter;
                  });
                },
                child: _isEditingAddressOfEventCenter
                    ? TextField(
                        controller: _addressOfEventCenterEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'addressof_eventcenter');
                            setState(() {
                              _addressOfEventCenter = newText;
                              _isEditingAddressOfEventCenter = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Address of event center cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _addressOfEventCenter,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(
                text: "Order Number",
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingOrderNumber = true;
                    _orderNumberEditingController.text = _orderNumber;
                  });
                },
                child: _isEditingOrderNumber
                    ? TextField(
                        controller: _orderNumberEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'order_number');
                            setState(() {
                              _orderNumber = newText;
                              _isEditingOrderNumber = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order number cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _orderNumber,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(
                text: "Ticket Type",
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingTicketType = true;
                    _ticketTypeEditingController.text = _ticketType;
                  });
                },
                child: _isEditingTicketType
                    ? TextField(
                        controller: _ticketTypeEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'ticket_type');
                            setState(() {
                              _ticketType = newText;
                              _isEditingTicketType = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Ticket type cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _ticketType,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              myColumn(
                text: "Purchase Date",
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    _isEditingPurchaseDate = true;
                    _purchaseDateEditingController.text = _purchaseDate;
                  });
                },
                child: _isEditingPurchaseDate
                    ? TextField(
                        controller: _purchaseDateEditingController,
                        style: const TextStyle(color: Colors.grey),
                        onSubmitted: (newText) {
                          if (newText.isNotEmpty) {
                            _saveText(newText, 'purchase_date');
                            setState(() {
                              _purchaseDate = newText;
                              _isEditingPurchaseDate = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Purchase Date cannot be empty'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      )
                    : Text(
                        _purchaseDate,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ticket Price",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onLongPress: () {
                              setState(() {
                                _isEditingTicketName = true;
                                _ticketNameEditingController.text = _ticketName;
                              });
                            },
                            child: _isEditingTicketName
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    child: TextField(
                                      controller: _ticketNameEditingController,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      onSubmitted: (newText) {
                                        if (newText.isNotEmpty) {
                                          _saveText(newText, 'ticket_name');
                                          setState(() {
                                            _ticketName = newText;
                                            _isEditingTicketName = false;
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Ticket name cannot be empty'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  )
                                : Text(
                                    _ticketName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _isEditingTicketPrice = true;
                            _ticketPriceEditingController.text = _ticketPrice;
                          });
                        },
                        child: _isEditingTicketPrice
                            ? SizedBox(
                                width: 50,
                                child: TextField(
                                  controller: _ticketPriceEditingController,
                                  style: const TextStyle(color: Colors.grey),
                                  onSubmitted: (newText) {
                                    if (newText.isNotEmpty) {
                                      _saveText(newText, 'ticket_price');
                                      setState(() {
                                        _ticketPrice = newText;
                                        _isEditingTicketPrice = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Ticket Price cannot be empty'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Text(
                                _ticketPrice,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myRow(
                        text: "Fee",
                      ),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _isEditingTicketFee = true;
                            _ticketFeeEditingController.text = _ticketFee;
                          });
                        },
                        child: _isEditingTicketFee
                            ? SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _ticketFeeEditingController,
                                  style: const TextStyle(color: Colors.grey),
                                  onSubmitted: (newText) {
                                    if (newText.isNotEmpty) {
                                      _saveText(newText, 'ticket_fee');
                                      setState(() {
                                        _ticketFee = newText;
                                        _isEditingTicketFee = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Ticket Fee cannot be empty'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Text(
                                _ticketFee,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myRow(
                        text: "Tax",
                      ),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _isEditingTicketTax = true;
                            _ticketTaxEditingController.text = _ticketTax;
                          });
                        },
                        child: _isEditingTicketTax
                            ? SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _ticketTaxEditingController,
                                  style: const TextStyle(color: Colors.grey),
                                  onSubmitted: (newText) {
                                    if (newText.isNotEmpty) {
                                      _saveText(newText, 'ticket_tax');
                                      setState(() {
                                        _ticketTax = newText;
                                        _isEditingTicketTax = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Ticket Tax cannot be empty'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Text(
                                _ticketTax,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      myRow(
                        text: "GRAND TOTAL",
                      ),
                      GestureDetector(
                        onLongPress: () {
                          setState(() {
                            _isEditingTicketGrandTotal = true;
                            _ticketGrandTotalEditingController.text =
                                _ticketGrandTotal;
                          });
                        },
                        child: _isEditingTicketGrandTotal
                            ? SizedBox(
                                width: 80,
                                child: TextField(
                                  controller:
                                      _ticketGrandTotalEditingController,
                                  style: const TextStyle(color: Colors.grey),
                                  onSubmitted: (newText) {
                                    if (newText.isNotEmpty) {
                                      _saveText(newText, 'ticket_grandtotal');
                                      setState(() {
                                        _ticketGrandTotal = newText;
                                        _isEditingTicketGrandTotal = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Ticket Grand Total cannot be empty'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            : Text(
                                _ticketGrandTotal,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Text ticketInfoText({text}) => Text(
        text,
        style: const TextStyle(color: Colors.grey),
      );

  Row myRow({
    text,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
        // Text(
        //   textt,
        //   style: const TextStyle(color: Colors.grey),
        // )
      ],
    );
  }

  Column myColumn({
    text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
