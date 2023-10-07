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
                  color: Colors.blue,
                )),
            child: const Center(
                // child: SvgPicture.asset(
                //   AppAssets.mail2,
                //   color: IklinColors.primaryColor,
                //   width: 38,
                //   height: 30,
                // ),
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
            child: Container(
              height: 35,
              width: MediaQuery.of(context).size.width * 0.5,
              color: Colors.blue,
              child: Center(
                  child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                      },
                      child: const Text("Continue"))),
            ),
          )
        ],
      ),
    );
  }
}
