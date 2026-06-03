import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferAuthorizationPage extends StatefulWidget {
  const TransferAuthorizationPage({super.key});

  @override
  State<TransferAuthorizationPage> createState() =>
      _TransferAuthorizationPageState();
}

class _TransferAuthorizationPageState extends State<TransferAuthorizationPage> {
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'TRANSFER SUCCESSFUL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 4, 84, 149),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'The transfer of ticket(s) to the email below is completed and the ticket(s) are being processed.The recipient will receive the ticket(s) within 1 - 3 hours',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
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
                            fontSize: 18,
                          ),
                        ),
                ),
                const SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
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
