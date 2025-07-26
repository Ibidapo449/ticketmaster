import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/EventInfo.dart';
import 'package:ticketmaster/providers/TimerProvider.dart';
import 'package:ticketmaster/providers/colorProvider.dart';
import 'package:ticketmaster/providers/croppedImageProvider.dart';
import 'package:ticketmaster/providers/event_providers.dart';
import 'package:ticketmaster/screens/widgets/TicketCard.dart';
import 'package:ticketmaster/screens/widgets/transerButtomSheet.dart';

/// Main Event Details screen
class EventDetails extends StatefulWidget {
  final EventInfo event;
  final double opacity1;
  final double opacity2;

  const EventDetails(
      {Key? key,
      required this.event,
      required this.opacity1,
      required this.opacity2})
      : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late final CountdownController _countdown;
  late final PageController _pageController;
  int _currentIndex = 0;

  // Toggle states
  bool _colorSell = true;
  bool _transferSell = true;
  bool _switchTicketCountTitle = false;

  // Editable fields
  String _ticketSelectionText = '2 Ticket Selected';
  String _seatText = '15, 16, 17, 18';
  late final TextEditingController _ticketTextController;
  late final TextEditingController _seatTextController;

  @override
  void initState() {
    super.initState();
    _countdown = CountdownController()..init();
    _pageController = PageController(viewportFraction: 0.9);
    _ticketTextController = TextEditingController();
    _seatTextController = TextEditingController();
    Future.microtask(() =>
        Provider.of<TimerProvider>(context, listen: false).loadCountdown());
  }

  @override
  void dispose() {
    _countdown.dispose();
    _pageController.dispose();
    _ticketTextController.dispose();
    _seatTextController.dispose();
    super.dispose();
  }

  Future<void> _saveBoolPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _onPageChanged(int index) => setState(() => _currentIndex = index);

  int visibleContainerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageProv = context.watch<CroppedImageProvider>();
    final colorProv = context.watch<ColorProvider>();
    return Scaffold(
      body: ListView(
        // padding: const EdgeInsets.all(8.0),
        children: [
          AnimatedOpacity(
            opacity: context.watch<EventProvider>().isSwitched2
                ? widget.opacity1
                : 1,
            duration: const Duration(seconds: 1),
            child: SizedBox(
              height: imageProv.image == null
                  ? MediaQuery.of(context).size.height * 0.64
                  : MediaQuery.of(context).size.height * 0.6,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: widget.event.ticketCount,
                itemBuilder: (_, idx) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: TicketCard(
                    event: widget.event,
                    index: idx,
                    colorSell: _colorSell,
                    transferSell: _transferSell,
                    countdown: _countdown,
                    ticketSelectionText: _ticketSelectionText,
                    seatText: _seatText,
                    switchTicketCountTitle: _switchTicketCountTitle,
                    onToggleCountTitle: (val) {
                      setState(() => _switchTicketCountTitle = val);
                      _saveBoolPref('getcountEvent', val);
                    },
                    onColorSellToggle: (val) {
                      setState(() => _colorSell = val);
                      _saveBoolPref('selldeactivate', val);
                    },
                    onTransferToggle: (val) {
                      setState(() => _transferSell = val);
                      _saveBoolPref('transferdeactivate', val);
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedOpacity(
            opacity: widget.opacity2,
            duration: const Duration(seconds: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.event.ticketCount,
                (i) => _buildIndicator(i == _currentIndex, context),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const SizedBox(height: 15),
          AnimatedOpacity(
            opacity: context.watch<EventProvider>().isSwitched2
                ? widget.opacity2
                : 1,
            duration: const Duration(seconds: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  label: 'Transfer',
                  colorProv: colorProv,
                  active: _transferSell,
                  onTap: () => _showTransferSheet(context),
                  onDoubleTap: () {
                    setState(() => _transferSell = !_transferSell);
                    _saveBoolPref('transferdeactivate', _transferSell);
                  },
                ),
                _buildActionButton(
                  label: 'Sell',
                  active: _colorSell,
                  colorProv: colorProv,
                  onTap: () {
                    setState(() => _colorSell = !_colorSell);
                    _saveBoolPref('selldeactivate', _colorSell);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          imageProv.image == null
              ? const SizedBox()
              : AnimatedOpacity(
                  duration: const Duration(seconds: 1),
                  opacity: context.watch<EventProvider>().isSwitched2
                      ? widget.opacity2
                      : 1,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 80,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(imageProv.image!, fit: BoxFit.cover)),
                  ),
                )
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isSelected, BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    final color = isSelected ? colorProv.currentColor : Colors.grey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        width: isSelected ? 8 : 7,
        height: isSelected ? 8 : 7,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
    required ColorProvider colorProv,
    VoidCallback? onDoubleTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: active
                ? colorProv.isPrimary
                    ? const Color(0xff0361cb)
                    : colorProv.currentColor
                : const Color(0xfff0eef1),
          ),
          alignment: Alignment.center,
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      );

  void _showTransferSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransferBottomSheet(event: widget.event),
    );
  }
}

/// Countdown logic separated
class CountdownController {
  Duration remaining = Duration.zero;
  Timer? _timer;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final endMillis = prefs.getInt('countdownEndTime') ?? 0;
    if (endMillis > 0) {
      final end = DateTime.fromMillisecondsSinceEpoch(endMillis);
      remaining = end.difference(DateTime.now());
      if (remaining.inSeconds > 0) _start();
    }
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining.inSeconds > 0) {
        remaining -= const Duration(seconds: 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  void dispose() => _timer?.cancel();
}
