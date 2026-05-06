import 'package:flutter/material.dart';
import '../../../models/user/kos_model.dart';
import '../../../core/color.dart';

class LocationPickerView extends StatelessWidget {
  final KostModel kost;
  const LocationPickerView({super.key, required this.kost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Stack(
            children: [
              // Map Image (Statik)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Image.network(
                  'https://via.placeholder.com/600x1200/1e3a8a/f8fafc?text=Malang+City+Map',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
                ),
              ),

              // Tombol Back
              Positioned(
                top: 25,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ),
              ),

              // Panel Alamat Bawah
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildAddressPanel(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Jl. Soekarno Hatta No. 100, Malang',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/personal_info',
                  arguments: {
                    'kost': kost,
                    'isJasa': true,
                    'fromLocation': 'Jl. Soekarno Hatta No. 100, Malang',
                    'toLocation': 'Jl. Soekarno Hatta No. 100, Malang',
                  },
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.amber),
              child: const Text(
                'Select Location',
                style: TextStyle(color: AppColors.darkBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
