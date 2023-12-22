import 'package:flutter/material.dart';
import 'package:ticketmaster/home.dart';

class TicketTransferSuccessfullModal extends StatelessWidget {
  const TicketTransferSuccessfullModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 282,
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
                border: Border.all(
                  color: const Color(0xff006ce7),
                )),
            child: const Center(
              child: Icon(
                Icons.done,
                size: 35,
                color: Color(0xff006ce7),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Successful !",
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 10),
          const Text(
            "Ticket Transfer was",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const Text(
            "successful.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
              },
              child: Container(
                height: 35,
                width: MediaQuery.of(context).size.width * 0.65,
                color: const Color(0xff006ce7),
                child: const Center(
                    child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }
}