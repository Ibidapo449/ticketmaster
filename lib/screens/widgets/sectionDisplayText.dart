import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SectionDisplay extends StatelessWidget {
  final String section;

  const SectionDisplay({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split the string by the first space
    final parts = section.split(' ');
    final firstPart = parts.first;
    final remainder = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(
            firstPart,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            minFontSize: 10,
            overflow: TextOverflow.ellipsis,
          ),
          // If there is any remainder (like "X2"), render it on a new line
          if (remainder.isNotEmpty)
            Text(
              remainder,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}
