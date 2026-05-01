import 'package:flutter/material.dart';
import '../../../core/color.dart';

class InvoiceStepper extends StatelessWidget {
  const InvoiceStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Step Profile (Samar/Opacity Rendah)
          _buildStep(Icons.person, "Profile", false),
          _buildLine(),
          // Step Payment (Aktif/Terang)
          _buildStep(Icons.credit_card, "Payment", true),
          _buildLine(),
          // Step Complete (Samar)
          _buildStep(Icons.assignment_turned_in, "Complete", false),
        ],
      ),
    );
  }

  Widget _buildStep(IconData icon, String label, bool isActive) {
    return Column(
      children: [
        Icon(icon, color: isActive ? AppColors.primary : AppColors.primary.withOpacity(0.3)),
        Text(label, style: TextStyle(
          fontSize: 10, 
          fontWeight: FontWeight.bold, 
          color: isActive ? AppColors.primary : AppColors.primary.withOpacity(0.3)
        )),
      ],
    );
  }

  Widget _buildLine() {
    return Container(height: 2, width: 40, color: AppColors.primary.withOpacity(0.1));
  }
}