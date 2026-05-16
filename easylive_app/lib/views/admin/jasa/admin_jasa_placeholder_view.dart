import 'package:flutter/material.dart';

class AdminJasaPlaceholderView extends StatelessWidget {
  const AdminJasaPlaceholderView({super.key});

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
                const Icon(Icons.miscellaneous_services_rounded,
                    size: 64, color: Color(0xFF243447)),
                const SizedBox(height: 16),
                const Text(
                  'Halaman Admin Jasa (placeholder)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF243447),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nanti ini bisa kamu ganti dengan halaman admin jasa yang sebenarnya.',
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
