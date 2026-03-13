import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/EventInfo.dart';
import 'package:ticketmaster/utils/general_admission_utils.dart';

class TicketDetails extends StatefulWidget {
  final EventInfo? event;

  const TicketDetails({
    super.key,
    this.event,
  });

  @override
  State<TicketDetails> createState() => _TicketDetailsState();
}

class _TicketDetailsState extends State<TicketDetails>
    with SingleTickerProviderStateMixin {
  static const Color _pageBackground = Color(0xFFF5F1EA);
  static const Color _ticketBlue = Color(0xFF0D4BFF);

  late final PageController _pageController;
  late final AnimationController _scannerController;

  int _currentIndex = 0;
  int _ticketCount = 1;

  String _artistName = 'USF Wind Ensemble';
  String _eventName = 'USF Wind Ensemble Side-By-Side With Spruce Creek HS';
  String _section = 'GENADM';
  String _row = 'GA';
  String _seat = '1';
  String _date = 'SUN APR 12, 2026';
  String _time = '14:00';
  String _location = 'Peter and Cynthia Zinober Concert Hall';
  String _imageUrl = '';
  String _ticketType = 'General Ticket';
  String _level = 'General Admission';

  bool _notesExpanded = false;
  bool _orderExpanded = true;
  bool _eventExpanded = false;
  bool _isInWalletViewMode = false;
  bool _isPageBlank = false;
  String? _editableImportantNotesMobile;
  String? _editableImportantNotesEntrance;
  String? _editableEventVenue;
  String? _editableOrderNumber;
  String? _editableLongBarcodeNumber;
  String _editableTicketFaceValue = r'$0.00';
  String _editableGrandTotal = r'$0.00';
  String _editablePurchaseDate = 'Tue, Feb 24, 2026';
  static const String _importantNotesMobileKey = 'important_notes_mobile';
  static const String _importantNotesEntranceKey = 'important_notes_entrance';
  static const String _eventInformationVenueKey = 'event_information_venue';
  static const String _orderDetailsOrderNumberKey = 'order_number';
  static const String _orderDetailsLongBarcodeKey = 'long_barcode_number';
  static const String _orderDetailsTicketFaceValueKey = 'ticket_face_value';
  static const String _orderDetailsGrandTotalKey = 'grand_total';
  static const String _orderDetailsPurchaseDateKey = 'purchase_date';
  static const String _ticketDetailsBlankModeKey = 'ticket_details_blank_mode';

  @override
  void initState() {
    super.initState();
    _loadBlankModePreference();
    _pageController = PageController(viewportFraction: 0.9);
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    if (widget.event != null) {
      _applyEventInfo(widget.event!);
      _loadOrderDetailsEdits();
    } else {
      _loadTicketData();
    }
  }

  Future<void> _loadBlankModePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool(_ticketDetailsBlankModeKey) ?? false;
    if (!mounted) {
      return;
    }
    setState(() {
      _isPageBlank = savedValue;
    });
  }

  Future<void> _setPageBlank(bool value) async {
    if (mounted) {
      setState(() {
        _isPageBlank = value;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ticketDetailsBlankModeKey, value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _loadTicketData() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) {
      return;
    }

    final savedTicketCount = prefs.getInt('numberOfTicket') ?? _ticketCount;

    setState(() {
      _artistName = prefs.getString('artistName') ?? _artistName;
      _eventName = prefs.getString('eventName') ?? _eventName;
      _section = prefs.getString('section') ?? _section;
      _row = prefs.getString('row') ?? _row;
      _seat = prefs.getString('seat') ?? _seat;
      _date = prefs.getString('date') ?? _date;
      _time = prefs.getString('time') ?? _time;
      _location = prefs.getString('location') ?? _location;
      _imageUrl = prefs.getString('image') ?? _imageUrl;
      _ticketType = prefs.getString('ticketType') ?? _ticketType;
      _level = prefs.getString('level') ?? _level;
      _ticketCount = savedTicketCount < 1 ? 1 : savedTicketCount;
    });

    await _loadOrderDetailsEdits();
  }

  void _applyEventInfo(EventInfo event) {
    _artistName = event.artistName;
    _eventName = event.eventName;
    _section = event.section;
    _row = event.row;
    _seat = event.seat;
    _date = event.date;
    _time = event.time;
    _location = event.location;
    _imageUrl = event.imageUrl;
    _ticketType = event.ticketType;
    _level = event.level;
    _ticketCount = event.ticketCount < 1 ? 1 : event.ticketCount;
  }

  String _displayTitle() {
    if (_eventName.trim().isNotEmpty &&
        _eventName.trim().toUpperCase() != 'N/A') {
      return _eventName;
    }
    return _artistName;
  }

  String _orderReference() {
    final letters = _artistName.replaceAll(RegExp(r'[^A-Za-z]'), '');
    final suffix = letters.isEmpty
        ? 'TKT'
        : (letters.length >= 3 ? letters.substring(0, 3) : letters)
            .toUpperCase();
    final raw = (_artistName + _date + _time).hashCode.abs();
    final digits = raw.toString().padLeft(7, '0');
    final shortDigits =
        digits.length > 7 ? digits.substring(0, 7) : digits.substring(0, 7);
    return 'Order #${shortDigits.substring(0, 2)}-${shortDigits.substring(2)}/$suffix';
  }

  String _subtitle() {
    final parts = <String>[];
    if (_time.trim().isNotEmpty && _time.trim().toUpperCase() != 'N/A') {
      parts.add(_time);
    } else if (_date.trim().isNotEmpty && _date.trim().toUpperCase() != 'N/A') {
      parts.add(_date);
    }
    if (_location.trim().isNotEmpty &&
        _location.trim().toUpperCase() != 'N/A') {
      parts.add(_location);
    }
    return parts.join(' - ');
  }

  String _accessLabel() {
    if (_level.trim().isNotEmpty && _level.trim().toUpperCase() != 'N/A') {
      return _level.toUpperCase();
    }
    if (_ticketType.trim().isNotEmpty &&
        _ticketType.trim().toUpperCase() != 'N/A') {
      return _ticketType.toUpperCase();
    }
    return 'GENERAL ADMISSION';
  }

  String _sectionLabel() {
    if (_section.trim().isNotEmpty && _section.trim().toUpperCase() != 'N/A') {
      return _section.toUpperCase();
    }
    return 'GENADM';
  }

  String _barcodeData(int index) {
    final titleToken =
        _displayTitle().replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
    final compactTitle = titleToken.isEmpty
        ? 'EVENT'
        : titleToken.substring(0, titleToken.length.clamp(0, 12));
    final dateToken = (_date + _time).replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    final seatToken =
        _seat.trim().isEmpty || _seat.trim() == '0' ? 'GA' : _seat.trim();
    final ticketNumber = (index + 1).toString().padLeft(2, '0');

    return '$compactTitle-$dateToken-${_sectionLabel()}-$seatToken-$ticketNumber';
  }

  String _orderDetailsEventScope() {
    final source = '$_artistName|$_eventName|$_date|$_time|$_location'
        .toLowerCase()
        .trim();
    final normalized = source
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final shortPart =
        normalized.length > 48 ? normalized.substring(0, 48) : normalized;
    return '${shortPart}_${source.hashCode.abs()}';
  }

  String _orderDetailsStorageKey(String fieldKey) {
    return 'ticket_order_details_${_orderDetailsEventScope()}_$fieldKey';
  }

  Future<void> _loadOrderDetailsEdits() async {
    final prefs = await SharedPreferences.getInstance();

    final orderNumber = prefs.getString(
      _orderDetailsStorageKey(_orderDetailsOrderNumberKey),
    );
    final importantNotesMobile = prefs.getString(
      _orderDetailsStorageKey(_importantNotesMobileKey),
    );
    final importantNotesEntrance = prefs.getString(
      _orderDetailsStorageKey(_importantNotesEntranceKey),
    );
    final eventInformationVenue = prefs.getString(
      _orderDetailsStorageKey(_eventInformationVenueKey),
    );
    final longBarcode = prefs.getString(
      _orderDetailsStorageKey(_orderDetailsLongBarcodeKey),
    );
    final ticketFaceValue = prefs.getString(
      _orderDetailsStorageKey(_orderDetailsTicketFaceValueKey),
    );
    final grandTotal = prefs.getString(
      _orderDetailsStorageKey(_orderDetailsGrandTotalKey),
    );
    final purchaseDate = prefs.getString(
      _orderDetailsStorageKey(_orderDetailsPurchaseDateKey),
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _editableImportantNotesMobile = importantNotesMobile;
      _editableImportantNotesEntrance = importantNotesEntrance;
      _editableEventVenue = eventInformationVenue;
      _editableOrderNumber = orderNumber;
      _editableLongBarcodeNumber = longBarcode;
      _editableTicketFaceValue = ticketFaceValue ?? r'$0.00';
      _editableGrandTotal = grandTotal ?? r'$0.00';
      _editablePurchaseDate = purchaseDate ?? 'Tue, Feb 24, 2026';
    });
  }

  Future<void> _saveOrderDetailEdit({
    required String fieldKey,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_orderDetailsStorageKey(fieldKey), value);
  }

  Future<void> _showTicketInfoSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.7,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          'Ticket Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),

                      // IMPORTANT NOTES
                      _buildAccordionItem(
                        title: 'IMPORTANT NOTES',
                        isOpen: _notesExpanded,
                        onTap: () {
                          setSheetState(() {
                            _notesExpanded = !_notesExpanded;
                          });
                        },
                        content: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildEditableOrderValue(
                                initialValue:
                                    _editableImportantNotesMobile ?? 'Mobile',
                                onChanged: (value) {
                                  _editableImportantNotesMobile = value;
                                  _saveOrderDetailEdit(
                                    fieldKey: _importantNotesMobileKey,
                                    value: value,
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'ENTRANCE',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildEditableOrderValue(
                                initialValue: _editableImportantNotesEntrance ??
                                    _accessLabel().toUpperCase(),
                                onChanged: (value) {
                                  _editableImportantNotesEntrance = value;
                                  _saveOrderDetailEdit(
                                    fieldKey: _importantNotesEntranceKey,
                                    value: value,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1),

                      // ORDER DETAILS
                      _buildAccordionItem(
                        title: 'ORDER DETAILS',
                        isOpen: _orderExpanded,
                        onTap: () {
                          setSheetState(() {
                            _orderExpanded = !_orderExpanded;
                          });
                        },
                        content: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildEditableOrderValue(
                                initialValue: _editableOrderNumber ??
                                    _orderReference().replaceAll('Order #', ''),
                                onChanged: (value) {
                                  _editableOrderNumber = value;
                                  _saveOrderDetailEdit(
                                    fieldKey: _orderDetailsOrderNumberKey,
                                    value: value,
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Long Barcode Number',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildEditableOrderValue(
                                initialValue: _editableLongBarcodeNumber ??
                                    _barcodeData(_currentIndex).toLowerCase(),
                                onChanged: (value) {
                                  _editableLongBarcodeNumber = value;
                                  _saveOrderDetailEdit(
                                    fieldKey: _orderDetailsLongBarcodeKey,
                                    value: value,
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Ticket Price',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Ticket Face Value',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 112,
                                    child: _buildEditableOrderValue(
                                      initialValue: _editableTicketFaceValue,
                                      textAlign: TextAlign.right,
                                      onChanged: (value) {
                                        _editableTicketFaceValue = value;
                                        _saveOrderDetailEdit(
                                          fieldKey:
                                              _orderDetailsTicketFaceValueKey,
                                          value: value,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'GRAND TOTAL',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 112,
                                    child: _buildEditableOrderValue(
                                      initialValue: _editableGrandTotal,
                                      textAlign: TextAlign.right,
                                      onChanged: (value) {
                                        _editableGrandTotal = value;
                                        _saveOrderDetailEdit(
                                          fieldKey: _orderDetailsGrandTotalKey,
                                          value: value,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Purchase Date',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildEditableOrderValue(
                                initialValue: _editablePurchaseDate,
                                onChanged: (value) {
                                  _editablePurchaseDate = value;
                                  _saveOrderDetailEdit(
                                    fieldKey: _orderDetailsPurchaseDateKey,
                                    value: value,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1),

                      // EVENT INFORMATION
                      _buildAccordionItem(
                        title: 'EVENT INFORMATION',
                        isOpen: _eventExpanded,
                        onTap: () {
                          setSheetState(() {
                            _eventExpanded = !_eventExpanded;
                          });
                        },
                        content: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Venue',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildEditableOrderValue(
                                initialValue: _editableEventVenue ?? _location,
                                onChanged: (value) {
                                  _editableEventVenue = value;
                                  _saveOrderDetailEdit(
                                    fieldKey: _eventInformationVenueKey,
                                    value: value,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1),

                      // TERMS & CONDITIONS
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Take care of your ticket, as it cannot be replaced if lost, stolen or destroyed, and is valid only for event and seat printed on ticket. This ticket is a revocable license to attend the event listed on the front of the ticket and is subject to the full terms found at www.ticketmaster.com. Such license may be revoked without refund for noncompliance with terms. Unlawful sale or attempted sale prohibited. Tickets obtained from unauthorized sources may be invalid, lost, stolen, or counterfeit and if so, are void. Maximum resale restrictions may apply. NY: if venue seats more than 5,000 persons, ticket may not be resold within 1,500 feet from the physical structure of this place of entertainment under penalty of law. and is valid only for event and seat printed on ticket. This ticket is a revocable license to attend the event listed on the front of the ticket and is subject to the full terms found at www.ticketmaster.com. Such license may be revoked without refund for noncompliance with terms. Unlawful sale or attempted sale prohibited. Tickets obtained from unauthorized sources may be invalid, lost, stolen, or counterfeit and if so, are void. Maximum resale restrictions may apply. NY: if venue seats more than 5,000 persons, ticket may not be resold within 1,500 feet from the physical structure of this place of entertainment under penalty of law. IF an event is not played, ticket may be exchanged for same price seat for either: (a) rescheduled event, if any; or, if applicable, (b) any event designated by the place of entertainment within 12 months of...',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEditableOrderValue({
    required String initialValue,
    required ValueChanged<String> onChanged,
    TextAlign textAlign = TextAlign.left,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      textAlign: textAlign,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildAccordionItem({
    required String title,
    required bool isOpen,
    required Widget content,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        if (isOpen) content,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackground,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {
          _setPageBlank(!_isPageBlank);
        },
        child: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 14),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final pageHeight = (constraints.maxHeight - 232)
                            .clamp(350.0, 640.0)
                            .toDouble();

                        return Column(
                          children: [
                            SizedBox(
                              height: pageHeight,
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: _ticketCount,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return _buildTicketPage(index);
                                },
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
                              child: Column(
                                children: [
                                  _buildPageCounter(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildWalletButton(),
                                      const SizedBox(width: 14),
                                      _buildInfoButton(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_isPageBlank)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: () {
                    _setPageBlank(false);
                  },
                  child: const ColoredBox(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 14, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF211E1A),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _displayTitle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF171412),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _subtitle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B645D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketPage(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFDCD4CA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 16,
              color: _ticketBlue,
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildTicketImage(),
                        Positioned(
                          top: 12,
                          left: 16,
                          right: 16,
                          child: _buildBarcodePanel(index),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _ticketType.trim().isEmpty ||
                                            _ticketType.trim().toUpperCase() ==
                                                'N/A'
                                        ? 'General Ticket'
                                        : _ticketType,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF181512),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _level.trim().isEmpty ||
                                            _level.trim().toUpperCase() == 'N/A'
                                        ? 'General Admission'
                                        : _level,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF6D655E),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTicketMetaOnly(index),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketMetaOnly(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SECTION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: Color(0xFF706961),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _sectionLabel(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Color(0xFF171412),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 7),
            color: const Color(0xFF171412),
            alignment: Alignment.center,
            child: Text(
              _accessLabel(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ),
          if (_row.trim().isNotEmpty &&
              !hasGeneralAdmissionRule(section: _section, row: _row)) ...[
            const SizedBox(height: 12),
            Text(
              'ROW $_row${_seat.trim().isNotEmpty && _seat != '0' ? '  ·  SEAT ${int.tryParse(_seat) != null ? int.parse(_seat) + index : _seat}' : ''}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF706961),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBarcodePanel(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7E0D7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 12, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Screenshots won\'t get you in',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6D655E),
                  ),
                ),
                Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
            child: SizedBox(
              height: 60,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: BarcodeWidget(
                          width: totalWidth,
                          height: 60,
                          data: _barcodeData(index),
                          barcode: Barcode.pdf417(
                            moduleHeight: 1.95,
                            preferredRatio: 5,
                          ),
                          drawText: false,
                          color: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _scannerController,
                        builder: (context, child) {
                          final scanX = totalWidth * _scannerController.value;
                          return CustomPaint(
                            painter: _BarcodeScanPainter(
                              scanX: scanX,
                              color: _ticketBlue,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketImage() {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEFE6DB),
      child: _imageUrl.trim().isEmpty
          ? const Center(
              child: Icon(
                Icons.image_outlined,
                size: 48,
                color: Color(0xFF9A9288),
              ),
            )
          : Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    size: 42,
                    color: Color(0xFF9A9288),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPageCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        '${_currentIndex + 1} of $_ticketCount',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF2A2622),
        ),
      ),
    );
  }

  Widget _buildWalletButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          _isInWalletViewMode = !_isInWalletViewMode;
        });
      },
      child: Container(
        height: 48,
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xFF171412),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isInWalletViewMode) ...[
              Image.asset(
                'assets/images/applewallet.png',
                width: 23,
                height: 23,
              ),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                _isInWalletViewMode ? 'View In Wallet' : 'Add to\nApple Wallet',
                textAlign: TextAlign.center,
                maxLines: _isInWalletViewMode ? 1 : 2,
                style: TextStyle(
                  fontSize: _isInWalletViewMode ? 14 : 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.05,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: _showTicketInfoSheet,
      child: Container(
        height: 48,
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFC6BDB2)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/info-circle-svgrepo-com.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(
                Color(0xFF171412),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 5),
            const Flexible(
              child: Text(
                'Ticket Info',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF171412),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Barcode scan line painter
// ---------------------------------------------------------------------------

class _BarcodeScanPainter extends CustomPainter {
  final double scanX;
  final Color color;

  _BarcodeScanPainter({required this.scanX, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Trailing blue wash — fades from the left edge up to scanX
    final trailLength = size.width * 0.45;
    final trailStart = (scanX - trailLength).clamp(0.0, size.width);
    final trailWidth = scanX - trailStart;

    if (trailWidth > 0) {
      final trailPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.08),
            color.withValues(alpha: 0.20),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(
          Rect.fromLTWH(trailStart, 0, trailWidth, size.height),
        );

      canvas.drawRect(
        Rect.fromLTWH(trailStart, 0, trailWidth, size.height),
        trailPaint,
      );
    }

    // Soft glow halo around the scan line (16px wide, centred on scanX)
    const glowHalfWidth = 8.0;
    final glowLeft = (scanX - glowHalfWidth).clamp(0.0, size.width);
    final glowRight = (scanX + glowHalfWidth).clamp(0.0, size.width);
    final glowWidth = glowRight - glowLeft;

    if (glowWidth > 0) {
      final glowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0.85),
            Colors.white.withValues(alpha: 0.90),
            color.withValues(alpha: 0.85),
            color.withValues(alpha: 0.25),
            Colors.transparent,
          ],
          stops: const [0.0, 0.2, 0.45, 0.5, 0.55, 0.8, 1.0],
        ).createShader(
          Rect.fromLTWH(glowLeft, 0, glowWidth, size.height),
        );

      canvas.drawRect(
        Rect.fromLTWH(glowLeft, 0, glowWidth, size.height),
        glowPaint,
      );
    }

    // Crisp 2px scan line
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(scanX, 0),
      Offset(scanX, size.height),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_BarcodeScanPainter oldDelegate) =>
      oldDelegate.scanX != scanX;
}
