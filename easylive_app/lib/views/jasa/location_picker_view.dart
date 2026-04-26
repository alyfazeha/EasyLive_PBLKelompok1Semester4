import 'package:flutter/material.dart';

class LocationPickerView extends StatelessWidget {
  const LocationPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.98,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                // Map Image (Statik)
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/112.6213,-7.9482,14,0/600x1200?access_token=pk.xxx',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: Colors.grey[200]),
                  ),
                ),

                // Tombol Back (WAJIB ADA)
                Positioned(
                  top: 25,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3E50)),
                      onPressed: () => Navigator.pop(context),
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
      ),
    );
  }

  Widget _buildAddressPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF2D3E50),
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
                // Tampilkan snackbar sebagai tanda berhasil
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location Selected!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFBC02D)),
              child: const Text('Select Location', style: TextStyle(color: Color(0xFF2D3E50))),
            ),
          ),
        ],
      ),
    );
  }
}