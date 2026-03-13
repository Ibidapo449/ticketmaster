import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/model/EventInfo.dart';
import 'package:ticketmaster/providers/colorProvider.dart';
import 'package:ticketmaster/providers/croppedImageProvider.dart';
import 'package:ticketmaster/screens/event_details_screen.dart';
import 'package:ticketmaster/screens/widgets/TicketInfo.dart';
import 'package:ticketmaster/screens/widgets/autoscrollText.dart';
import 'package:ticketmaster/screens/widgets/sectionDisplayText.dart';
import 'package:ticketmaster/utils/general_admission_utils.dart';

import '../ticket_details_screen.dart';

/// Individual ticket card
class TicketCard extends StatefulWidget {
  final EventInfo event;
  final int index;
  final CountdownController countdown;
  final bool colorSell;
  final bool transferSell;
  final String ticketSelectionText;
  final String seatText;
  final bool switchTicketCountTitle;
  final ValueChanged<bool> onToggleCountTitle;
  final ValueChanged<bool> onColorSellToggle;
  final ValueChanged<bool> onTransferToggle;

  TicketCard({
    Key? key,
    required this.event,
    required this.index,
    required this.countdown,
    required this.colorSell,
    required this.transferSell,
    required this.ticketSelectionText,
    required this.seatText,
    required this.switchTicketCountTitle,
    required this.onToggleCountTitle,
    required this.onColorSellToggle,
    required this.onTransferToggle,
  }) : super(key: key);

  @override
  _TicketCardState createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  int visibleContainerIndex = 1;
  CrossAxisAlignment _gaCrossAxisAlignment = CrossAxisAlignment.end;

  static const String _gaAlignmentKey = 'ga_cross_axis_alignment';

  @override
  void initState() {
    super.initState();
    _loadGACrossAxisAlignment();
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

  Future<void> _toggleGACrossAxisAlignment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gaCrossAxisAlignment = _gaCrossAxisAlignment == CrossAxisAlignment.end
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.end;
    });
    await prefs.setString(_gaAlignmentKey,
        _gaCrossAxisAlignment == CrossAxisAlignment.center ? 'center' : 'end');
  }

  @override
  Widget build(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        children: [
          // All your normal content:
          Padding(
            // ensure we leave 1px at the bottom so the line isn't covered
            padding: const EdgeInsets.only(bottom: 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTicketTypeBar(context),
                _buildSeatInfo(context),
                _buildImageBanner(context),
                TicketInfoSection(
                  event: widget.event,
                ),
              ],
            ),
          ),

          // The precise bottom‐edge line:
          Positioned(
            left: 12, // same as your BorderRadius
            right: 12, // so it doesn’t hit the curves
            bottom: 0, // flush with the very bottom
            child: Container(
              height: 1.5, // exactly 1px tall
              color: colorProv.currentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTypeBar(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
          color: colorProv.currentColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(),
          //I want to reduce the size of this text to show everything when it's long but max font-size is 16
          SizedBox(
            width: MediaQuery.of(context).size.width * .7,
            child: AutoSizeText(widget.event.ticketType,
                maxLines: 1,
                maxFontSize: 16,
                textAlign: TextAlign.center,
                // overflow: TextOverflow.clip,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TicketDetails(),
              ));
            },
            child: SvgPicture.asset(
              'assets/images/info.svg',
              color: Colors.white,
              height: 18,
              width: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatInfo(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    final isGeneralAdmission = hasGeneralAdmissionRule(
      section: widget.event.section,
      row: widget.event.row,
    );
    final baseSeat = int.tryParse(widget.event.seat);
    final seatNumber = widget.event.seat == '0'
        ? ''
        : isGeneralAdmission
            ? 'GA'
            : baseSeat == null
                ? widget.event.seat
                : (baseSeat + widget.index).toString();

    return GestureDetector(
      onTap: () {
        colorProv.toggle();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 3, bottom: 25),
        color: colorProv.currentColor,
        child: Row(
          crossAxisAlignment: isGeneralAdmission
              ? _gaCrossAxisAlignment
              : CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(child: _infoColumn('SEC', widget.event.section)),
            // if GA-1, show single label; otherwise show ROW and SEAT columns
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
          Text(label, style: const TextStyle(color: Colors.white)),
          // const SizedBox(height: 2),
          SectionDisplay(section: value),
        ],
      );

  Widget _buildImageBanner(BuildContext context) {
    final imageProv = context.watch<CroppedImageProvider>();
    return Stack(
      children: [
        Image.network(widget.event.imageUrl,
            fit: BoxFit.cover,
            height: imageProv.image == null ? 230 : 220,
            width: double.infinity),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.95),
                ],
                stops: const [
                  0.4,
                  0.65,
                  1.0
                ], // Starts fading from 50%, fully black by 100%
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.event.eventName == ''
                    ? Text(widget.event.artistName,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18))
                    : widget.event.artistName == ''
                        ? Text(widget.event.eventName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18))
                        : Text(
                            '${widget.event.artistName} | ${widget.event.eventName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                const SizedBox(height: 4),
                FittedBox(
                  child: Text(
                      '${widget.event.date}  ${widget.event.time} • ${widget.event.location}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
