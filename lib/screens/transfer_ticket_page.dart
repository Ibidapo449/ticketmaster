import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/screens/transfer_authorization_page.dart';

class TransferTicketPage extends StatefulWidget {
  const TransferTicketPage({super.key});

  @override
  State<TransferTicketPage> createState() => _TransferTicketPageState();
}

class _TransferTicketPageState extends State<TransferTicketPage> {
  String _email = 'ibidapodavid10@gmail.com';
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('transfer_email') ?? _email;
    });
  }

  Future<void> _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('transfer_email', email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 33, 33),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Transfer Authorization',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'AUTHORIZE TICKET(S)',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color.fromARGB(255, 4, 84, 149),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Confirm the tickets(s) transfer to the email \nbelow',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.15),
            GestureDetector(
              onLongPress: () {
                setState(() {
                  _isEditing = true;
                  _controller.text = _email;
                });
              },
              child: _isEditing
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            onSubmitted: (value) async {
                              setState(() {
                                _email = value;
                                _isEditing = false;
                              });
                              await _saveEmail(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            setState(() {
                              _email = _controller.text;
                              _isEditing = false;
                            });
                            await _saveEmail(_controller.text);
                          },
                        ),
                      ],
                    )
                  : Text(
                      _email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: const Color.fromARGB(255, 4, 84, 149),
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'The ticket(s) will be permanently \ntransferred and available in the \n recipient account',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TransferAuthorizationPage(),
                ));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 1, 71, 127)),
                child: const Center(
                  child: Text(
                    'Authorize Tickets',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}