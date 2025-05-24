import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider extends ChangeNotifier {
  Duration remainingTime = Duration.zero;
  Timer? timer;

  Future<void> loadCountdown() async {
    final prefs = await SharedPreferences.getInstance();
    final endTimeMillis = prefs.getInt('countdownEndTime') ?? 0;

    if (endTimeMillis != 0) {
      final endTime = DateTime.fromMillisecondsSinceEpoch(endTimeMillis);
      final currentTime = DateTime.now();

      remainingTime = endTime.difference(currentTime);
      notifyListeners();
      if (remainingTime.inSeconds > 0) {
        startTimer();
      } else {
        remainingTime = Duration.zero;
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingTime.inSeconds > 0) {
        remainingTime -= Duration(seconds: 1);
        notifyListeners();
      } else {
        timer?.cancel();
      }
    });
  }
}
