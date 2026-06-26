import 'package:flutter/material.dart';

class TicketTransferConfirmationModal extends StatelessWidget {
  final Future<void> Function() onContinue;

  const TicketTransferConfirmationModal({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 262,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue),
            ),
            child: const Center(
                child: Icon(
              Icons.warning_amber_rounded,
              size: 35,
              color: Colors.blue,
            )),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "Do you really want to transfer the ticket(s) to this recipient?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GestureDetector(
              onTap: onContinue,
              child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.65,
                color: const Color(0xff006ce7),
                child: const Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
