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
            // Logo Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                'images/easylive.png',
                width: 200,
              ),
            ),

            const SizedBox(height: 20),

            // Loading Indicator
            const CircularProgressIndicator(
              color: AppColors.titleName,
            ),
          ],
        ),
      ),
    );
  }
}