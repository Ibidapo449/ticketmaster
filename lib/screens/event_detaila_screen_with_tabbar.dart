// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:apple_maps_flutter/apple_maps_flutter.dart' as apple_maps;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/EventInfo.dart';
import 'package:ticketmaster/screens/TabbarPageforEventsDetails/add_ons.dart';
import 'package:ticketmaster/screens/ticket_details_screen.dart';
import 'package:ticketmaster/screens/widgets/authenticationBottomSheet.dart';
import 'package:ticketmaster/screens/widgets/transerButtomSheet.dart';
import 'package:ticketmaster/utils/general_admission_utils.dart';

class EventDetailaScreenWithTabbar extends StatefulWidget {
  final String artistName;
  final String eventName;
  final String section;
  final String row;
  final String seat;
  final String date;
  final String location;
  final String address;
  final String time;
  final String image;
  final String ticketType;
  final String level;
  final int number_of_ticket;

  const EventDetailaScreenWithTabbar({
    super.key,
    required this.artistName,
    required this.eventName,
    required this.section,
    required this.row,
    required this.seat,
    required this.date,
    required this.location,
    required this.address,
    required this.time,
    required this.image,
    required this.ticketType,
    required this.level,
    required this.number_of_ticket,
  });

  @override
  State<EventDetailaScreenWithTabbar> createState() =>
      _EventDetailaScreenWithTabbarState();
}

class _EventDetailaScreenWithTabbarState
    extends State<EventDetailaScreenWithTabbar> with TickerProviderStateMixin {
  static const String _transferDisabledKey = 'event_tabbar_transfer_disabled';
  static const String _legacyMapAccessKey = 'mapAccess';
  static const String _sellActiveKeyPrefix = 'event_tabbar_sell_active';
  static const double _expandedHeroHeight = 302.0;
  static const double _collapsedHeroBodyHeight = 72.0;
  static const double _heroImageHeight = 146.0;

  late final TabController _tabController;
  late final ScrollController _scrollController;
  late final AnimationController _shimmerController;
  double _scrollOffset = 0;
  bool _isAuthenticating = false;
  bool _isTransferEnabled = true;
  bool _isSellActive = false;
  bool _canUseAppleMap = true;
  bool _isResolvingMapAccess = true;
  bool _showInitialShimmer = true;
  String? _customOrderReference;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1350),
    )..repeat();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);
    _loadTransferState();
    _loadMapAccessState();
    _loadCustomOrderReference();
    _loadSellState();
    _scheduleInitialShimmerExit();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _shimmerController.dispose();
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final nextOffset = _scrollController.offset;
    if ((nextOffset - _scrollOffset).abs() < 0.5 || !mounted) {
      return;
    }

    setState(() {
      _scrollOffset = nextOffset;
    });
  }

  Future<void> _scheduleInitialShimmerExit() async {
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) {
      return;
    }

    _shimmerController.stop();
    setState(() {
      _showInitialShimmer = false;
    });
  }

  Future<void> _loadTransferState() async {
    final prefs = await SharedPreferences.getInstance();
    final transferEnabled = !(prefs.getBool(_transferDisabledKey) ?? false);

    if (!mounted) {
      return;
    }

    setState(() {
      _isTransferEnabled = transferEnabled;
    });
  }

  String _sellStateStorageKey() {
    final raw =
        '${widget.artistName}_${widget.eventName}_${widget.date}_${widget.time}_${widget.location}'
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
            .replaceAll(RegExp(r'_+'), '_')
            .trim();
    final compact = raw.length > 48 ? raw.substring(0, 48) : raw;
    return '${_sellActiveKeyPrefix}_${compact}_${raw.hashCode.abs()}';
  }

  Future<void> _loadSellState() async {
    final prefs = await SharedPreferences.getInstance();
    final isSellActive = prefs.getBool(_sellStateStorageKey()) ?? false;

    if (!mounted) {
      return;
    }

    setState(() {
      _isSellActive = isSellActive;
    });
  }

  Future<void> _setSellState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sellStateStorageKey(), value);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSellActive = value;
    });
  }

  Future<void> _loadMapAccessState() async {
    final prefs = await SharedPreferences.getInstance();
    final email = (prefs.getString('accessAccount') ?? '').trim().toLowerCase();
    final scopedMapKey = email.isEmpty ? null : 'mapAccess_$email';
    final cachedValue = scopedMapKey == null
        ? null
        : (prefs.getBool(scopedMapKey) ?? prefs.getBool(_legacyMapAccessKey));

    if (mounted && cachedValue != null) {
      setState(() {
        _canUseAppleMap = cachedValue;
      });
    }

    if (email.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _canUseAppleMap = cachedValue ?? true;
        _isResolvingMapAccess = false;
      });
      return;
    }

    try {
      final query = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      bool canUseMap = cachedValue ?? true;
      if (query.docs.isNotEmpty) {
        final userData = query.docs.first.data();
        final fieldValue = userData['mapAccess'];
        if (fieldValue is bool) {
          canUseMap = fieldValue;
        } else {
          canUseMap = true;
        }
      }

      if (scopedMapKey != null) {
        await prefs.setBool(scopedMapKey, canUseMap);
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _canUseAppleMap = canUseMap;
        _isResolvingMapAccess = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _canUseAppleMap = cachedValue ?? true;
        _isResolvingMapAccess = false;
      });
    }
  }

  String _orderReferenceStorageKey() {
    final raw =
        '${widget.artistName}_${widget.eventName}_${widget.date}_${widget.time}_${widget.location}'
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
            .replaceAll(RegExp(r'_+'), '_')
            .trim();
    final compact = raw.length > 48 ? raw.substring(0, 48) : raw;
    return 'order_ref_${compact}_${raw.hashCode.abs()}';
  }

  Future<void> _loadCustomOrderReference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getString(_orderReferenceStorageKey())?.trim();

    if (!mounted) {
      return;
    }

    setState(() {
      _customOrderReference =
          (savedValue == null || savedValue.isEmpty) ? null : savedValue;
    });
  }

  Future<void> _editOrderReference() async {
    String draftValue = _orderReference();
    final newValue = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Order Reference'),
          content: TextFormField(
            initialValue: draftValue,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            onChanged: (value) {
              draftValue = value;
            },
            decoration: const InputDecoration(
              hintText: 'Order #45-31498/FLO',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(''),
              child: const Text('Reset'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(draftValue.trim()),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted || newValue == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = _orderReferenceStorageKey();

    if (newValue.isEmpty) {
      await prefs.remove(key);
      if (!mounted) {
        return;
      }
      setState(() {
        _customOrderReference = null;
      });
      return;
    }

    await prefs.setString(key, newValue);
    if (!mounted) {
      return;
    }

    setState(() {
      _customOrderReference = newValue;
    });
  }

  String _displayTitle() {
    final event = widget.eventName.trim().toUpperCase();
    final artist = widget.artistName.trim().toUpperCase();
    if (event.isNotEmpty && artist.isNotEmpty) {
      return '$event - $artist';
    }
    return event.isNotEmpty ? event : artist;
  }

  String _orderReference() {
    if (_customOrderReference != null && _customOrderReference!.isNotEmpty) {
      return _customOrderReference!;
    }

    final letters = widget.artistName.replaceAll(RegExp(r'[^A-Za-z]'), '');
    final suffix = letters.isEmpty
        ? 'TKT'
        : (letters.length >= 3 ? letters.substring(0, 3) : letters)
            .toUpperCase();
    final raw = (widget.artistName + widget.date + widget.time).hashCode.abs();
    final digits = raw.toString().padLeft(7, '0');
    final shortDigits =
        digits.length > 7 ? digits.substring(0, 7) : digits.substring(0, 7);
    return 'Order #${shortDigits.substring(0, 2)}-${shortDigits.substring(2)}/$suffix';
  }

  EventInfo _eventInfo() {
    return EventInfo(
      artistName: widget.artistName,
      eventName: widget.eventName,
      section: widget.section,
      row: widget.row,
      seat: widget.seat,
      date: widget.date,
      location: widget.location,
      time: widget.time,
      imageUrl: widget.image,
      ticketType: widget.ticketType,
      level: widget.level,
      ticketCount: widget.number_of_ticket < 1 ? 1 : widget.number_of_ticket,
    );
  }

  void _openTicketDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TicketDetails(
          event: _eventInfo(),
        ),
      ),
    );
  }

  Future<void> _startTransferFlow() async {
    if (!_isTransferEnabled) {
      return;
    }

    setState(() {
      _isAuthenticating = true;
    });

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) {
      return;
    }

    setState(() {
      _isAuthenticating = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => AuthenticationBottomSheet(
        onAuthenticationComplete: _showTransferSheet,
      ),
    );
  }

  void _showTransferSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransferBottomSheet(
        event: _eventInfo(),
        onTransferSubmitted: _handleTransferSubmitted,
      ),
    );
  }

  Future<void> _handleTransferSubmitted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_transferDisabledKey, true);

    if (!mounted) {
      return;
    }

    setState(() {
      _isTransferEnabled = false;
    });

    Navigator.of(context).pop();
  }

  Future<void> _reactivateTransfer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transferDisabledKey);

    if (!mounted) {
      return;
    }

    setState(() {
      _isTransferEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topInset = mediaQuery.padding.top;
    final bottomInset = mediaQuery.padding.bottom;
    final collapsedHeroHeight = topInset + _collapsedHeroBodyHeight;
    final initialSheetTop = topInset + _expandedHeroHeight;
    final revealDistance = initialSheetTop - collapsedHeroHeight;
    final revealProgress = (_scrollOffset / revealDistance).clamp(0.0, 1.0);

    if (_showInitialShimmer) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F3F6),
        body: _buildLoadingShimmer(
          topInset: topInset,
          bottomInset: bottomInset,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: _buildFixedHero(
              context: context,
              topInset: topInset,
              initialSheetTop: initialSheetTop,
              revealProgress: revealProgress,
            ),
          ),
          Positioned.fill(
            top: collapsedHeroHeight,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _openTicketDetails();
                    },
                    child: SizedBox(height: revealDistance),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedTabBarDelegate(
                    TabBar(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      controller: _tabController,
                      labelColor: Colors.black,
                      unselectedLabelColor: const Color(0xFF707070),
                      indicatorColor: Colors.black,
                      indicatorWeight: 2.5,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: EdgeInsets.zero,
                      dividerColor: const Color(0xFFE0E0E0),
                      labelPadding: EdgeInsets.zero,
                      labelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Tickets'),
                        Tab(text: 'Extras'),
                      ],
                    ),
                  ),
                ),
                if (_tabController.index == 0) ..._buildTicketSlivers(),
                if (_tabController.index == 1) ..._buildExtraSlivers(),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    height: 96 + bottomInset,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomInset + 12,
            child: IgnorePointer(
              ignoring: _tabController.index != 0,
              child: AnimatedOpacity(
                opacity: _tabController.index == 0 ? 1 : 0,
                duration: const Duration(milliseconds: 180),
                child: Center(child: _buildBottomPill()),
              ),
            ),
          ),
          if (_isAuthenticating)
            Positioned.fill(
              child: Container(
                color: Colors.white.withValues(alpha: 0.82),
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer({
    required double topInset,
    required double bottomInset,
  }) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: topInset + 328,
                child: Stack(
                  children: [
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Color(0xFFE5E2E7),
                      ),
                    ),
                    Positioned(
                      top: topInset + 8,
                      left: 12,
                      child: _buildShimmerBox(
                        width: 48,
                        height: 48,
                        borderRadius: BorderRadius.circular(24),
                        baseColor: const Color(0xFF6E6A72),
                        highlightColor: const Color(0xFF86818A),
                      ),
                    ),
                    Positioned(
                      top: topInset + 12,
                      right: 12,
                      child: _buildShimmerBox(
                        width: 96,
                        height: 42,
                        borderRadius: BorderRadius.circular(21),
                        baseColor: const Color(0xFF6E6A72),
                        highlightColor: const Color(0xFF86818A),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  14,
                                  24,
                                  14,
                                  18,
                                ),
                                color: const Color(0xFFA6A3A9),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildShimmerBox(
                                      width: 160,
                                      height: 14,
                                      borderRadius: BorderRadius.circular(4),
                                      baseColor: const Color(0xFFBBB8BE),
                                      highlightColor: const Color(0xFFD0CDD2),
                                    ),
                                    const SizedBox(height: 18),
                                    _buildShimmerBox(
                                      width: double.infinity,
                                      height: 20,
                                      borderRadius: BorderRadius.circular(4),
                                      baseColor: const Color(0xFFBBB8BE),
                                      highlightColor: const Color(0xFFD0CDD2),
                                    ),
                                    const SizedBox(height: 14),
                                    _buildShimmerBox(
                                      width: 280,
                                      height: 18,
                                      borderRadius: BorderRadius.circular(4),
                                      baseColor: const Color(0xFFBBB8BE),
                                      highlightColor: const Color(0xFFD0CDD2),
                                    ),
                                    const SizedBox(height: 22),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildShimmerBox(
                                            width: double.infinity,
                                            height: 14,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            baseColor: const Color(0xFFBBB8BE),
                                            highlightColor:
                                                const Color(0xFFD0CDD2),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        _buildShimmerBox(
                                          width: 20,
                                          height: 20,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          baseColor: const Color(0xFFBBB8BE),
                                          highlightColor:
                                              const Color(0xFFD0CDD2),
                                        ),
                                        const SizedBox(width: 6),
                                        _buildShimmerBox(
                                          width: 26,
                                          height: 18,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          baseColor: const Color(0xFFBBB8BE),
                                          highlightColor:
                                              const Color(0xFFD0CDD2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: -10,
                                left: 0,
                                child: _buildShimmerBox(
                                  width: 226,
                                  height: 20,
                                  borderRadius: BorderRadius.circular(3),
                                  baseColor: const Color(0xFFB0ADB3),
                                  highlightColor: const Color(0xFFC7C4C9),
                                ),
                              ),
                            ],
                          ),
                          _buildShimmerBox(
                            width: double.infinity,
                            height: 48,
                            borderRadius: BorderRadius.zero,
                            baseColor: const Color(0xFF9D9AA1),
                            highlightColor: const Color(0xFFB5B2B8),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildShimmerBox(
                                width: 84,
                                height: 14,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 3,
                                color: const Color(0xFF343336),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 28),
                        Expanded(
                          child: Column(
                            children: [
                              _buildShimmerBox(
                                width: 84,
                                height: 14,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                height: 2,
                                color: const Color(0xFFD6D4D8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildShimmerBox(
                                width: 190,
                                height: 18,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              const SizedBox(height: 12),
                              _buildShimmerBox(
                                width: 92,
                                height: 13,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ),
                        _buildShimmerBox(
                          width: 30,
                          height: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _buildLoadingTicketCard(),
                    const SizedBox(height: 14),
                    _buildLoadingTicketCard(),
                    SizedBox(height: 120 + bottomInset),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: bottomInset + 12,
          child: Center(
            child: _buildShimmerBox(
              width: 190,
              height: 56,
              borderRadius: BorderRadius.circular(28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingTicketCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2F5),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildShimmerBox(
                width: 132,
                height: 15,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmerBox(
                      width: 56,
                      height: 12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    _buildShimmerBox(
                      width: 92,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 12),
                    _buildShimmerBox(
                      width: 92,
                      height: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: _buildShimmerBox(
                    width: 170,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    required double? width,
    required double height,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(8)),
    Color baseColor = const Color(0xFFE7E4E9),
    Color highlightColor = const Color(0xFFF3F1F5),
  }) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final slide = (_shimmerController.value * 2) - 1;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment(-1.2 - slide, -0.15),
              end: Alignment(1.2 - slide, 0.15),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: const [0.18, 0.5, 0.82],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFixedHero({
    required BuildContext context,
    required double topInset,
    required double initialSheetTop,
    required double revealProgress,
  }) {
    final helpOpacity =
        1 - Curves.easeIn.transform((revealProgress / 0.45).clamp(0.0, 1.0));
    final compactOpacity = Curves.easeOut
        .transform(((revealProgress - 0.28) / 0.72).clamp(0.0, 1.0));
    final compactTicketOpacity = Curves.easeOut
        .transform(((revealProgress - 0.58) / 0.42).clamp(0.0, 1.0));

    return ColoredBox(
      color: Colors.white,
      child: SizedBox(
        height: initialSheetTop,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: topInset + _heroImageHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.black45,
                          size: 40,
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.14),
                          Colors.black.withValues(alpha: 0.42),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: topInset + 8,
                    left: 12,
                    child: _buildOverlayCircleButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: topInset + 12,
                    right: 12,
                    child: IgnorePointer(
                      ignoring: helpOpacity == 0,
                      child: AnimatedOpacity(
                        opacity: helpOpacity,
                        duration: const Duration(milliseconds: 160),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _reactivateTransfer,
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.42),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: const Text(
                                'Help',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: topInset + 10,
                    left: 70,
                    right: 90,
                    child: IgnorePointer(
                      ignoring: compactOpacity == 0,
                      child: AnimatedOpacity(
                        opacity: compactOpacity,
                        duration: const Duration(milliseconds: 180),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _displayTitle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.88),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: topInset + 8,
                    right: 12,
                    child: IgnorePointer(
                      ignoring: compactTicketOpacity == 0,
                      child: AnimatedOpacity(
                        opacity: compactTicketOpacity,
                        duration: const Duration(milliseconds: 180),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _openTicketDetails,
                            borderRadius: BorderRadius.circular(22),
                            child: Container(
                              width: 48,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFF004EE9),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.22),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 5),
                                child: Image.asset(
                                  'assets/images/smarticon.png',
                                  width: 18,
                                  height: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 13,
                    bottom: 0,
                    child: _buildHeroDateChip(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: _buildHeroSummaryCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroDateChip() {
    return Container(
      color: const Color(0xFF232323),
      padding: const EdgeInsets.fromLTRB(14, 8, 18, 8),
      child: Text(
        '${widget.date.toUpperCase()} • ${widget.time}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  Widget _buildHeroSummaryCard() {
    const panelColor = Color(0xFF232323);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {}, // Blocks scroll view taps
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                color: panelColor,
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Text(
                        _displayTitle(),
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.18,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.location,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.25,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_num_outlined,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'x${widget.number_of_ticket}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Material(
                color: const Color(0xFF004EE9),
                child: InkWell(
                  onTap: _openTicketDetails,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/smarticon.png',
                          width: 18,
                          height: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'View Tickets',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
      ],
    );
  }

  List<Widget> _buildTicketSlivers() {
    final ticketCount =
        widget.number_of_ticket < 1 ? 1 : widget.number_of_ticket;

    return [
      SliverToBoxAdapter(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onLongPress: _editOrderReference,
                            child: Text(
                              _orderReference(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF222222),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'x$ticketCount Tickets',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF6C6C6C),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.more_vert, color: Color(0xFF3B3B3B)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                for (int i = 0; i < ticketCount; i++) _buildTicketCard(i + 1),
                const SizedBox(height: 14),
                _buildDirectionsSection(),
                const SizedBox(height: 20),
                _buildShareSection(),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    border: Border(
                      top: BorderSide(
                        color: Colors.black.withValues(alpha: 0.08),
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Share You’re Going',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF232323),
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.ios_share_outlined,
                          size: 18, color: Color(0xFF232323)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildExtraSlivers() {
    return const [
      SliverToBoxAdapter(
        child: AddOns(),
      ),
      SliverFillRemaining(
        hasScrollBody: false,
        child: ColoredBox(
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildDirectionsSection() {
    final geocodeQuery =
        widget.address.trim().isNotEmpty ? widget.address : widget.location;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _VenueDirectionsMap(
          geocodeQuery: geocodeQuery,
          pinTitle: widget.location.trim().isNotEmpty
              ? widget.location
              : geocodeQuery,
          pinSubtitle: widget.address.trim().isNotEmpty &&
                  widget.address.trim() != widget.location.trim()
              ? widget.address
              : null,
          hasMapAccess: _canUseAppleMap,
          isAccessLoading: _isResolvingMapAccess,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: const Color(0xFFEBEBEB),
          alignment: Alignment.center,
          child: const Text(
            'Get Directions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF232323),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShareSection() {
    return Container(
      color: const Color(0xFFF4F4F4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 210,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Blurred background image
                Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.black),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                ),
                // Content
                Row(
                  children: [
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 12,
                      child: Container(
                        margin: const EdgeInsets.only(top: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    widget.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.black45,
                                          size: 32,
                                        ),
                                      );
                                    },
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Container(
                                      color: const Color(0xFF232323),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      child: Text(
                                        '${widget.date.toUpperCase()} • ${widget.time}',
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 12),
                              color: const Color(0xFF1A1A1A),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _displayTitle(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    widget.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 24, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'YOU GOT\nTICKETS!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                height: 1.1,
                                color: Colors.white,
                                letterSpacing: 0.6,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 90,
                              height: 5,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            child: Text(
              'Post on Social Media',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: const Color(0xFF181818),
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
            child: Text(
              'Build hype for the event, and share that you got tickets with your friends and family.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.55,
                color: Colors.black.withValues(alpha: 0.72),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(int ticketNumber) {
    final isGA = hasGeneralAdmissionRule(
      section: widget.section,
      row: widget.row,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEEE),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Text(
              widget.ticketType.trim().isNotEmpty
                  ? widget.ticketType
                  : (isGA ? 'General Admission Ticket' : 'General Ticket'),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF232323),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.95),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: isGA
                  ? [
                      _buildMetaBlock(
                        label: 'SECTION',
                        value: generalAdmissionSectionDisplay(widget.section),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAccessBlock(
                          value: 'GENERAL ADMISSION',
                        ),
                      ),
                    ]
                  : [
                      _buildMetaBlock(
                          label: 'SECTION',
                          value: widget.section.toUpperCase(),
                          alignEnd: false),
                      const SizedBox(width: 8),
                      _buildMetaBlock(
                          label: 'ROW',
                          value: widget.row.toUpperCase(),
                          alignCenter: true),
                      const SizedBox(width: 8),
                      _buildMetaBlock(
                          label: 'SEAT',
                          value: _seatValueForTicket(ticketNumber),
                          alignEnd: true),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  String _seatValueForTicket(int ticketNumber) {
    final rawSeat = widget.seat.trim().toUpperCase();
    if (rawSeat.isEmpty) {
      return rawSeat;
    }

    final baseSeat = int.tryParse(rawSeat);
    if (baseSeat != null) {
      return (baseSeat + ticketNumber - 1).toString();
    }

    final suffixMatch = RegExp(r'^(.*?)(\d+)$').firstMatch(rawSeat);
    if (suffixMatch == null) {
      return rawSeat;
    }

    final prefix = suffixMatch.group(1) ?? '';
    final numericPart = int.tryParse(suffixMatch.group(2) ?? '');
    if (numericPart == null) {
      return rawSeat;
    }

    return '$prefix${numericPart + ticketNumber - 1}';
  }

  Widget _buildMetaBlock(
      {required String label,
      required String value,
      bool alignEnd = false,
      bool alignCenter = false}) {
    return Column(
      crossAxisAlignment: alignCenter
          ? CrossAxisAlignment.center
          : (alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start),
      children: [
        Text(
          label,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: Color(0xFF7C7C7C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF202020),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessBlock({
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF202020),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomPill() {
    return Container(
      width: 190,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFloatingAction(
              label: 'Transfer',
              icon: Icons.north_east,
              enabled: _isTransferEnabled,
              isActive: _isTransferEnabled,
              onTap: () async {
                await _setSellState(false);
                _startTransferFlow();
              },
            ),
          ),
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: const Color(0xFFE2E2E2),
          ),
          Expanded(
            child: _buildFloatingAction(
              label: 'Sell',
              icon: _isSellActive ? Icons.north_east : Icons.sell_outlined,
              isActive: _isSellActive,
              onTap: () async {
                await _setSellState(!_isSellActive);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAction({
    required String label,
    required IconData icon,
    bool enabled = true,
    bool isActive = true,
    VoidCallback? onTap,
  }) {
    final isHighlighted = enabled && isActive;
    final iconColor =
        isHighlighted ? const Color(0xFF2A5AA8) : const Color(0xFFD7D7D7);
    final textColor =
        isHighlighted ? const Color(0xFF404040) : const Color(0xFFB7B7B7);

    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: enabled ? (onTap ?? () {}) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _VenueDirectionsMap extends StatefulWidget {
  final String geocodeQuery;
  final String pinTitle;
  final String? pinSubtitle;
  final bool hasMapAccess;
  final bool isAccessLoading;

  const _VenueDirectionsMap({
    required this.geocodeQuery,
    required this.pinTitle,
    this.pinSubtitle,
    required this.hasMapAccess,
    required this.isAccessLoading,
  });

  @override
  State<_VenueDirectionsMap> createState() => _VenueDirectionsMapState();
}

class _VenueDirectionsMapState extends State<_VenueDirectionsMap> {
  late Future<_ResolvedVenueLocation?> _resolvedLocationFuture;

  @override
  void initState() {
    super.initState();
    _resolvedLocationFuture = _resolveLocation();
  }

  @override
  void didUpdateWidget(covariant _VenueDirectionsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.geocodeQuery != widget.geocodeQuery) {
      _resolvedLocationFuture = _resolveLocation();
    }
  }

  Future<_ResolvedVenueLocation?> _resolveLocation() async {
    final query = widget.geocodeQuery.trim();
    if (query.isEmpty) {
      return null;
    }

    try {
      final locations = await geocoding.locationFromAddress(query);
      if (locations.isEmpty) {
        return null;
      }

      final first = locations.first;
      return _ResolvedVenueLocation(
        latitude: first.latitude,
        longitude: first.longitude,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isAccessLoading) {
      return _buildFallbackCard(
        message: 'Checking map access...',
        isLoading: true,
      );
    }

    if (!widget.hasMapAccess) {
      return _buildDisabledMapImageCard();
    }

    if (Theme.of(context).platform != TargetPlatform.iOS) {
      return _buildFallbackCard(
        message: 'Apple Maps preview is available on iPhone.',
      );
    }

    return FutureBuilder<_ResolvedVenueLocation?>(
      future: _resolvedLocationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildFallbackCard(
            message: 'Loading Apple Map...',
            isLoading: true,
          );
        }

        final resolvedLocation = snapshot.data;
        if (resolvedLocation == null) {
          return _buildFallbackCard(
            message: 'Unable to load this venue on Apple Maps.',
          );
        }

        final target = apple_maps.LatLng(
          resolvedLocation.latitude,
          resolvedLocation.longitude,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 210,
            width: double.infinity,
            child: apple_maps.AppleMap(
              initialCameraPosition: apple_maps.CameraPosition(
                target: target,
                zoom: 14.5,
              ),
              compassEnabled: false,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              rotateGesturesEnabled: false,
              pitchGesturesEnabled: false,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: true,
              annotations: <apple_maps.Annotation>{
                apple_maps.Annotation(
                  annotationId: apple_maps.AnnotationId('venue'),
                  position: target,
                  infoWindow: apple_maps.InfoWindow(
                    title: widget.pinTitle,
                    snippet: widget.pinSubtitle,
                  ),
                  icon: apple_maps.BitmapDescriptor.markerAnnotationWithHue(
                    apple_maps.BitmapDescriptor.hueRed,
                  ),
                ),
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackCard({
    required String message,
    bool isLoading = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        height: 240,
        width: double.infinity,
        color: const Color(0xFFEDEDED),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            else
              const Icon(
                Icons.map_outlined,
                size: 42,
                color: Color(0xFF7D7D7D),
              ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5E5E5E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisabledMapImageCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/map3.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFEDEDED),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.map_outlined,
                    size: 42,
                    color: Color(0xFF7D7D7D),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.04),
                    Colors.black.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResolvedVenueLocation {
  final double latitude;
  final double longitude;

  const _ResolvedVenueLocation({
    required this.latitude,
    required this.longitude,
  });
}

class _PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  const _PinnedTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedTabBarDelegate oldDelegate) {
    return oldDelegate.tabBar != tabBar;
  }
}
