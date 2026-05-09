import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../controllers/user/home_controller.dart';
import '../../../widgets/user/home/bottom_navbar.dart';
import 'detail_jasa_user_view.dart';

class JasaVehicle {
  final String name;
  final String address;
  final String image;
  final String price;
  final String description;
  final List<String> specifications;
  final int availableUnits;

  const JasaVehicle({
    required this.name,
    required this.address,
    required this.image,
    required this.price,
    required this.description,
    required this.specifications,
    required this.availableUnits,
  });
}

const List<JasaVehicle> userVehicles = [
  JasaVehicle(
    name: 'AUTOCAR EXPRESS',
    address: 'Jl. Cengger Ayam, Lowokwaru',
    image: 'assets/images/pickup-removed.png',
    price: 'Rp 1.500.000,-',
    description:
        'AUTOCAR Express menyediakan layanan sewa mobil untuk pindahan, ganti kos, dan pengantaran barang dengan kendaraan yang bersih serta pengemudi berpengalaman.',
    specifications: [
      '4 x 6 meter',
      'en-suite bathroom',
      '2 seat',
      'soft sponge',
    ],
    availableUnits: 5,
  ),
  JasaVehicle(
    name: 'TRUCK BOX',
    address: 'Jl. Soekarno Hatta, Malang',
    image: 'assets/images/mobilBox-BackgroundRemover.jpg',
    price: 'Rp 2.500.000,-',
    description:
        'Truck box cocok untuk pindahan besar dengan perlindungan barang lebih aman dari hujan dan panas selama perjalanan.',
    specifications: ['6 x 8 meter', 'closed box', '2 seat', 'heavy duty'],
    availableUnits: 3,
  ),
  JasaVehicle(
    name: 'PICKUP HARIAN',
    address: 'Jl. Ijen, Malang',
    image: 'assets/images/pickup-removed.png',
    price: 'Rp 900.000,-',
    description:
        'Pickup harian untuk kebutuhan pindahan ringan, pengiriman lemari, kasur, meja, dan barang kos area Malang.',
    specifications: ['4 x 5 meter', 'open deck', '2 seat', 'light cargo'],
    availableUnits: 4,
  ),
  JasaVehicle(
    name: 'MOVING VAN',
    address: 'Jl. Veteran, Malang',
    image: 'assets/images/mobilBox-BackgroundRemover.jpg',
    price: 'Rp 1.800.000,-',
    description:
        'Moving van praktis untuk pindahan apartemen atau kos dengan kapasitas sedang dan jadwal pemesanan fleksibel.',
    specifications: [
      '5 x 6 meter',
      'closed cabin',
      '2 seat',
      'soft suspension',
    ],
    availableUnits: 2,
  ),
];

class JasaView extends StatefulWidget {
  const JasaView({super.key});

  @override
  State<JasaView> createState() => _JasaViewState();
}

class _JasaViewState extends State<JasaView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<JasaVehicle> get _filteredVehicles {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return userVehicles;

    return userVehicles.where((vehicle) {
      return vehicle.name.toLowerCase().contains(query) ||
          vehicle.address.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userName = HomeController.getUserName();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 54, 22, 72),
                decoration: const BoxDecoration(
                  color: AppColors.darkBlue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
                child: _Header(userName: userName),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: -24,
                child: _SearchField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 46),
          const Text(
            'List All Your Vehicle',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _filteredVehicles.isEmpty
                ? const Center(child: Text('No vehicle found'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 106),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _filteredVehicles.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 13),
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return _VehicleCard(
                        vehicle: vehicle,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailJasaUserView(vehicle: vehicle),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 0) {
            Navigator.pushReplacementNamed(context, '/history');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/booking');
          }
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String userName;

  const _Header({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.darkBlue,
              size: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $userName',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: AppColors.background,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Welcome to EasyLive !',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 12),
      decoration: InputDecoration(
        hintText: 'Search',
        hintStyle: const TextStyle(fontFamily: 'Montserrat', fontSize: 11),
        prefixIcon: const Icon(Icons.search_rounded, size: 18),
        suffixIcon: const Icon(Icons.filter_alt_rounded, size: 18),
        filled: true,
        fillColor: AppColors.lightGreyAlt,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final JasaVehicle vehicle;
  final VoidCallback onTap;

  const _VehicleCard({required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 92,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.lightGreyAlt,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(vehicle.image, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vehicle.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 9,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    vehicle.price,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlue,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_horiz_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
