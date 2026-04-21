import 'package:flutter/material.dart';
import '../../controllers/splash_controller.dart';
import '../../models/splash_model.dart';
import '../../core/color.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = SplashController();
  final SplashModel _model = SplashModel();

  @override
  void initState() {
    super.initState();
    _controller.startTimer(context, _model.duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo-easylive.png',
              width: 450,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
