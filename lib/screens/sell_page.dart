// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketmaster/home_navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:ticketmaster/providers/croppedImageProvider.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  final _formKey = GlobalKey<FormState>();
  int days = 0;
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndCropImage(BuildContext context) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 12),
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
        ),
      ],
    );
    if (croppedFile == null) return;

    final file = File(croppedFile.path);
    await Provider.of<CroppedImageProvider>(context, listen: false)
        .setImage(file);
  }

  Future<void> startCountdown(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final countdownDuration = Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      );
      final endTime = DateTime.now().add(countdownDuration);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('countdownEndTime', endTime.millisecondsSinceEpoch);
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomeNavBar()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CroppedImageProvider>(
      builder: (context, imageProv, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Set Countdown Timer')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Image picker with delete icon
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () => _pickAndCropImage(context),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: imageProv.image != null
                                ? Image.file(imageProv.image!,
                                    fit: BoxFit.cover)
                                : const Center(
                                    child: Text('Tap to add image'),
                                  ),
                          ),
                        ),
                      ),
                      // Delete button
                      if (imageProv.image != null)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black45,
                            child: IconButton(
                              icon: const Icon(Icons.delete,
                                  size: 18, color: Colors.white),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('selectedImagePath');
                                imageProv.setImage(null);
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Countdown fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNumberField('Days', (val) => days = val),
                      _buildNumberField('Hours', (val) => hours = val),
                      _buildNumberField('Minutes', (val) => minutes = val),
                      _buildNumberField('Seconds', (val) => seconds = val),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => startCountdown(context),
                    child: const Text('Start Countdown'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNumberField(String label, void Function(int) onSaved) {
    return SizedBox(
      width: 70,
      child: TextFormField(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: label,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.0),
          ),
        ),
        keyboardType: TextInputType.number,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Required' : null,
        onSaved: (value) => onSaved(int.tryParse(value ?? '') ?? 0),
      ),
    );
  }
}
