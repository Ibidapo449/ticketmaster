import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:barcode/barcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ticketmaster/model/EventInfo.dart';

class BarcodeScreen extends StatefulWidget {
  final EventInfo event;

  const BarcodeScreen({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  State<BarcodeScreen> createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen>
    with TickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;
  late AnimationController _slowScannerController;
  late Animation<double> _slowScannerAnimation;
  bool _isForward = true;

  // --- BEGIN: Add state for GA alignment (mirroring TicketCard) ---
  CrossAxisAlignment _gaCrossAxisAlignment = CrossAxisAlignment.end;
  static const String _gaAlignmentKey = 'ga_cross_axis_alignment';

  // --- BEGIN: Add index state for seat navigation ---
  int _index = 0;
  // --- END: index state ---

  @override
  void initState() {
    super.initState();

    _loadGACrossAxisAlignment();
    _scannerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scannerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scannerController,
      curve: Curves.easeInOut,
    ));

    _slowScannerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _slowScannerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slowScannerController,
      curve: Curves.easeInOut,
    ));

    _isForward = true;
    _scannerController.addStatusListener((status) async {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _isForward = !_isForward;
        await Future.delayed(const Duration(milliseconds: 180));
        if (mounted) {
          if (_isForward) {
            _scannerController.forward(from: 0);
            // Only start the shadow line after the delay
            Future.delayed(const Duration(milliseconds: 180), () {
              if (mounted) _slowScannerController.forward(from: 0);
            });
          } else {
            _scannerController.reverse(from: 1);
            // Only start the shadow line after the delay
            Future.delayed(const Duration(milliseconds: 180), () {
              if (mounted) _slowScannerController.reverse(from: 1);
            });
          }
        }
      }
    });
    // Start both, but slow scanner is delayed
    _scannerController.forward();
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) _slowScannerController.forward();
    });
  }

  Future<void> _loadGACrossAxisAlignment() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_gaAlignmentKey);

    setState(() {
      _gaCrossAxisAlignment = value == 'center'
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end;
    });
  }

  void _toggleGACrossAxisAlignment() {
    setState(() {
      _gaCrossAxisAlignment = _gaCrossAxisAlignment == CrossAxisAlignment.end
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end;
    });
  }
  // --- END: GA alignment state ---

  @override
  void dispose() {
    _scannerController.dispose();
    _slowScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background image with blur
            Positioned.fill(
              child: Image.network(
                widget.event.imageUrl,
                fit: BoxFit.cover,
                color: Colors.black.withOpacity(0.7),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            // Blur overlay
            Positioned.fill(
              child: Container(
                color:
                    Colors.black.withOpacity(0.4), // Semi-transparent overlay
              ),
            ),
            // --- BEGIN: Bottom gradient overlay ---
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 250, // Adjust height as needed for effect
              child: IgnorePointer(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        // 50% opaque deep purple
                        Color(0x804B0082),
                        // 35% opaque electric blue
                        Color(0x593AB8FF),
                        // 25% opaque aqua
                        Color(0x3F00E5FF),
                        // fully transparent
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            // --- END: Bottom gradient overlay ---
            // Content
            Column(
              children: [
                _buildTopNavigationBar(),
                const SizedBox(height: 40),
                _buildTicketType(),
                const SizedBox(height: 60),
                _buildTicketDetails(),
                const SizedBox(height: 80),
                _buildBarcodeCard(),
                const SizedBox(height: 20),
                _buildAppleWalletButton(),
                const SizedBox(height: 40),
                _buildLevelType()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Container(
      color: const Color.fromARGB(255, 23, 23, 23),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${widget.event.artistName}: ${widget.event.eventName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,

                        fontSize:
                            20, // Set to a very large value to allow FittedBox to shrink as needed
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.event.date}, ${widget.event.time} - ${widget.event.location}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'Help',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketType() {
    return Text(
      widget.event.ticketType,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildLevelType() {
    return Text(
      widget.event.level,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTicketDetails() {
    // --- BEGIN: Copy logic from TicketCard _buildSeatInfo ---
    final seatNumber = widget.event.seat == '0'
        ? ''
        : widget.event.row == 'GA'
            ? 'GA'
            : (int.parse(widget.event.seat) + _index).toString();
    final isGeneralAdmission =
        widget.event.row == 'GA' && int.parse(widget.event.seat) == 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.only(top: 3, bottom: 25),
        // color: const Color(0xFF1a1a2e), // Use a fallback color
        child: Row(
          crossAxisAlignment: isGeneralAdmission
              ? _gaCrossAxisAlignment
              : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(child: _infoColumn('SEC', widget.event.section)),
            ...(isGeneralAdmission
                ? [
                    GestureDetector(
                      onTap: _toggleGACrossAxisAlignment,
                      child: const SizedBox(
                        height: 25,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'General Admission',
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                : [
                    _infoColumn('ROW', widget.event.row),
                    _infoColumn('SEAT', seatNumber),
                  ]),
          ],
        ),
      ),
    );
  }

  Column _infoColumn(String label, String value) => Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ],
      );

  Widget _buildBarcodeCard() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Swiping left (negative velocity) increases seat, right (positive) decreases
        setState(() {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            // Swipe left
            if (_index < (widget.event.ticketCount) - 1) {
              _index++;
            }
          } else if (details.primaryVelocity != null &&
              details.primaryVelocity! > 0) {
            // Swipe right
            if (_index > 0) {
              _index--;
            }
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildBarcode(),
            const SizedBox(height: 10),
            const Text(
              "Screenshots won't get you in",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcode() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          // Main PDF417 barcode
          BarcodeWidget(
            data: 'YOUR PAYLOAD HERE', // whatever you need to encode
            barcode: Barcode.pdf417(), // <--- PDF‑417 symbology
            width: 350,
            height: 120,
            drawText: false, // hide the human-readable line
            backgroundColor: Colors.white, // match your design
          ),
          // Animated scanner line (main)
          AnimatedBuilder(
            animation: _scannerAnimation,
            builder: (context, child) {
              return Positioned(
                left: _scannerAnimation.value *
                    MediaQuery.of(context).size.width *
                    0.8,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFF2196F3),
                        Color(0xFF2196F3),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
          // Animated scanner line (slow, wider, semi-transparent)
          AnimatedBuilder(
            animation: _slowScannerAnimation,
            builder: (context, child) {
              return Positioned(
                left: _slowScannerAnimation.value *
                    MediaQuery.of(context).size.width *
                    0.8,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 13,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        const Color(0xFF2196F3).withOpacity(0.5),
                        const Color(0xFF2196F3).withOpacity(0.5),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppleWalletButton() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.55,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 23, 23, 23),
          borderRadius: BorderRadius.circular(8)),
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
            const SizedBox(
              width: 15,
            ),
            const Text(
              "Add to Apple Wallet",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      )),
    );
  }
}
