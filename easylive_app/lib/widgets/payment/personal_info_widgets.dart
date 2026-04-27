import 'package:flutter/material.dart';
import '../../core/color.dart'; // Pastikan path ke AppColors benar

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 25),
      decoration: const BoxDecoration(
        color: AppColors.primary, // Menggunakan paletmu
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 15),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Personal Information",
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Complete the steps to get started",
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PersonalStepper extends StatelessWidget {
  const PersonalStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStep(Icons.person, "Profile", true),
          _buildLine(),
          _buildStep(Icons.credit_card, "Payment", false),
          _buildLine(),
          _buildStep(Icons.assignment_turned_in, "Complete", false),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Icon(icon, color: isActive ? AppColors.primary : Colors.black38),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? AppColors.primary : Colors.black38,
          ),
        ),
      ],
    );
  }

  Widget _buildLine() {
    return Container(
      height: 2,
      width: 50,
      color: AppColors.primary.withOpacity(0.2),
    );
  }
}
