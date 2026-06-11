import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../controllers/user/home_controller.dart';
import '../../../controllers/user/jasa_controller.dart';
import '../../../widgets/user/home/bottom_navbar.dart';
import '../../../widgets/user/kosPage/filtering.dart';
import 'detail_jasa_user_view.dart';

import '../../../models/user/jasa_vehicle_model.dart';

class JasaView extends StatefulWidget {
  const JasaView({super.key});

  @override
  State<JasaView> createState() => _JasaViewState();
}

class _JasaViewState extends State<JasaView> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  List<JasaVehicle> _allVehicles = [];

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadJasa();
  }

  Future<void> _loadJasa() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await JasaController.fetchJasaList();
      if (!mounted) return;
      setState(() {
        _allVehicles = result;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<JasaVehicle> get _filteredVehicles {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _allVehicles;

    return _allVehicles.where((vehicle) {
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
                  onFilterTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      builder: (context) => FilterBottomSheet(
                        onApply: (location, priceRange) {
                          // Filtering untuk jasa: pakai location (address)
                          // dan priceRange (parse dari string price jika tersedia).
                          setState(() {
                            // mapping priceRange ke _searchQuery tidak ideal, jadi kita
                            // hanya pakai location untuk filter minimal sesuai style kos.
                            if (location != null &&
                                location.toString().trim().isNotEmpty) {
                              _searchQuery = location.toString();
                              _searchController.text = location.toString();
                            } else {
                              _searchQuery = '';
                              _searchController.clear();
                            }
                          });
                        },
                      ),
                    );
                  },
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _filteredVehicles.isEmpty
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
  final VoidCallback onFilterTap;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onFilterTap,
  });

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
        suffixIcon: IconButton(
          onPressed: onFilterTap,
          icon: const Icon(Icons.filter_alt_rounded, size: 18),
        ),
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
