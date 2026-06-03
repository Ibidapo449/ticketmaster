import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/providers/colorProvider.dart';

class AuthenticationBottomSheet extends StatefulWidget {
  final VoidCallback onAuthenticationComplete;

  const AuthenticationBottomSheet({
    Key? key,
    required this.onAuthenticationComplete,
  }) : super(key: key);

  @override
  State<AuthenticationBottomSheet> createState() =>
      _AuthenticationBottomSheetState();
}

class _AuthenticationBottomSheetState extends State<AuthenticationBottomSheet> {
  bool _isLoading = true;
  bool _isConfirming = false;
  String _code = '';
  String _phoneNumber = '7793'; // Default phone number
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
    // Show loading for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _phoneNumber = prefs.getString('phoneNumber') ?? '7793';
    });
  }

  void _savePhoneNumber(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
    setState(() {
      _phoneNumber = phoneNumber;
    });
  }

  void _showEditPhoneDialog() {
    TextEditingController phoneController =
        TextEditingController(text: _phoneNumber);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Phone Number'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Last 4 digits of phone number',
              border: OutlineInputBorder(),
              prefixText: '******',
            ),
            maxLength: 4,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newPhoneNumber = phoneController.text;
                if (newPhoneNumber.length == 4) {
                  _savePhoneNumber(newPhoneNumber);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter exactly 4 digits')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(String value, int index) {
    setState(() {
      _code = _controllers.map((c) => c.text).join();
    });

    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _confirmCode() async {
    if (_code.length == 6) {
      setState(() {
        _isConfirming = true;
      });

      // Simulate confirmation delay
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pop();
        widget.onAuthenticationComplete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorProv = context.watch<ColorProvider>();
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping anywhere
        FocusScope.of(context).unfocus();
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xff0361cb),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Authentication',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 80), // Balance the cancel button
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? Center(
                      child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: colorProv.currentColor.withAlpha(150),
                      ),
                    ))
                  : Column(
                      children: [
                        // Passcode image section
                        SizedBox(
                          // height: 200
                          width: double.infinity,
                          // padding: const EdgeInsets.all(40),

                          child: Image.asset(
                            'assets/images/passcode.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),

                        // White content section
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Authenticate Your Account',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: _showEditPhoneDialog,
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          height: 1.4,
                                        ),
                                        children: [
                                          const TextSpan(
                                            text:
                                                'A one-time code has been sent to ******',
                                          ),
                                          TextSpan(
                                            text: _phoneNumber,
                                          ),
                                          const TextSpan(
                                            text:
                                                '. Please enter your code below to continue.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  const Text(
                                    'One-Time Code',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Single text field for code input
                                  TextField(
                                    controller: _controllers[0],
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 2,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: Color(0xff0361cb),
                                          width: 2,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _code = value;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  const Text(
                                    'It may take a minute to receive your code.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const Spacer(),

                                  // Confirm button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 43,
                                    child: ElevatedButton(
                                      onPressed:
                                          _code.length == 6 && !_isConfirming
                                              ? _confirmCode
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _code.length == 6
                                            ? const Color(0xff0361cb)
                                            : const Color(0xffb3d4fc),
                                        disabledBackgroundColor:
                                            const Color(0xffb3d4fc),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: _isConfirming
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            )
                                          : const Text(
                                              'Confirm Code',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
