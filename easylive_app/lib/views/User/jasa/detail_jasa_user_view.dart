import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/user/kos_model.dart';
import 'jasa_view.dart';
import 'route_card.dart';

class DetailJasaUserView extends StatefulWidget {
  final JasaVehicle vehicle;

  const DetailJasaUserView({super.key, required this.vehicle});

  @override
  State<DetailJasaUserView> createState() => _DetailJasaUserViewState();
}

class _DetailJasaUserViewState extends State<DetailJasaUserView> {
  bool _isFavorite = true;

  int _priceNumber(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  void _selectVehicle() {
    final selectedKost = KostModel(
      name: widget.vehicle.name,
      address: widget.vehicle.address,
      image: widget.vehicle.image,
      price: _priceNumber(widget.vehicle.price),
      description: widget.vehicle.description,
      specifications: widget.vehicle.specifications,
      availableRooms: widget.vehicle.availableUnits,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => JasaRouteView(kost: selectedKost),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeaderImage(
                      vehicle: widget.vehicle,
                      isFavorite: _isFavorite,
                      onFavorite: () =>
                          setState(() => _isFavorite = !_isFavorite),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vehicle.name,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            widget.vehicle.description,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 12,
                              color: AppColors.primary,
                              height: 1.22,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              widget.vehicle.price,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 17),
                          const Text(
                            'Vehicle Specifications',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.vehicle.specifications.join('\n'),
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              Text(
                                'Available : ${widget.vehicle.availableUnits} Unit',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
              child: ElevatedButton(
                onPressed: _selectVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.darkBlue,
                  elevation: 4,
                  shadowColor: AppColors.black.withValues(alpha: 0.18),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Select Vehicle',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  final JasaVehicle vehicle;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const _HeaderImage({
    required this.vehicle,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 245,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: const Color(0xFF1F252B),
            child: Image.asset(vehicle.image, fit: BoxFit.contain),
          ),
          Positioned(
            left: 18,
            top: 18,
            child: _SquareIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            right: 18,
            top: 18,
            child: _SquareIconButton(
              icon: isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              onTap: onFavorite,
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(icon, color: AppColors.darkBlue, size: 20),
      ),
    );
  }
}
