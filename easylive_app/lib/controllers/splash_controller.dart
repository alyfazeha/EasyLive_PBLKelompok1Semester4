import 'dart:async';
import 'package:flutter/material.dart';

class SplashController {
  Timer? _timer;

  void startTimer(BuildContext context, int seconds) {
    _timer = Timer(Duration(seconds: seconds), () {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}