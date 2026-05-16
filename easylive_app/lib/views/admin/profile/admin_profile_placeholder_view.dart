import 'package:flutter/material.dart';

class AdminProfilePlaceholderView extends StatelessWidget {
  const AdminProfilePlaceholderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 64,
                  color: Color(0xFF243447),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Halaman Admin Profile (placeholder)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF243447),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nanti ini bisa kamu ganti dengan halaman admin profile yang sebenarnya.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
