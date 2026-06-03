import 'package:flutter/material.dart';

class AddOns extends StatelessWidget {
  const AddOns({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_activity_outlined,
                size: 34,
                color: Color(0xFF6A6A6A),
              ),
              SizedBox(height: 12),
              Text(
                'No extras available for this event.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF353535),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
