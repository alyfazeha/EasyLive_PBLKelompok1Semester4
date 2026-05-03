import 'package:flutter/material.dart';
import '../../../core/color.dart';

class ComingSoonView extends StatelessWidget {
  final String title;
  const ComingSoonView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: AppColors.primary),
      body: Center(child: Text('Coming Soon: $title')),
    );
  }
}
