import 'package:flutter/material.dart';

import '../../../core/color.dart';
import '../../../models/user/kos_model.dart';
import '../../../models/user/jasa_vehicle_model.dart';
import '../../../widgets/user/jasa/route_card.dart';

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
      id: widget.vehicle.id,
      name: widget.vehicle.name,
      address: widget.vehicle.address,
      image: widget.vehicle.image,
      price: _priceNumber(widget.vehicle.price),
      description: widget.vehicle.description,
      specifications: widget.vehicle.specifications,
      availableRooms: 1,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => JasaRouteView(kost: selectedKost)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
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
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Nama Jasa + Badge Tipe Mobil
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.vehicle.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 21,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.darkBlue,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (widget.vehicle.specifications.isNotEmpty)
                                _BadgeLabel(
                                  label: widget.vehicle.specifications.first,
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Alamat
                          if (widget.vehicle.address.isNotEmpty)
                            _IconRow(
                              icon: Icons.location_on_outlined,
                              text: widget.vehicle.address,
                            ),

                          // Kecamatan • Kota
                          if (widget.vehicle.kecamatan.isNotEmpty ||
                              widget.vehicle.kota.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _IconRow(
                              icon: Icons.map_outlined,
                              text:
                                  '${widget.vehicle.kecamatan} • ${widget.vehicle.kota}',
                            ),
                          ],

                          // Nomor HP
                          if (widget.vehicle.nomorHp.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _IconRow(
                              icon: Icons.phone_outlined,
                              text: widget.vehicle.nomorHp,
                            ),
                          ],

                          // Nomor Plat
                          if (widget.vehicle.nomorPlat.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _IconRow(
                              icon: Icons.credit_card_outlined,
                              text: 'Plat: ${widget.vehicle.nomorPlat}',
                            ),
                          ],

                          const SizedBox(height: 14),

                          // Harga / km
                          Row(
                            children: [
                              const Text(
                                'Harga / km',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 13,
                                  color: Color(0xFF657384),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                widget.vehicle.price,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.darkBlue,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),
                          const Divider(color: Color(0xFFE0E6EC), height: 1),
                          const SizedBox(height: 18),

                          // Deskripsi
                          if (widget.vehicle.description.isNotEmpty) ...[
                            const Text(
                              'Deskripsi',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.vehicle.description,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                                color: AppColors.primary,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Spesifikasi Kendaraan (tipe_mobil + kapasitas)
                          if (widget.vehicle.specifications.isNotEmpty) ...[
                            const Text(
                              'Spesifikasi Kendaraan',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.darkBlue,
                              ),
                            ),
                            const SizedBox(height: 9),
                            Column(
                              children: widget.vehicle.specifications
                                  .map(
                                    (spec) => _SpecificationRow(label: spec),
                                  )
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
              child: ElevatedButton(
                onPressed: _selectVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.yellow,
                  foregroundColor: AppColors.darkBlue,
                  elevation: 8,
                  shadowColor: AppColors.black.withValues(alpha: 0.2),
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'Pilih Kendaraan',
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

// ─────────────────────────────────────────────────────────────────────────────
// Header Image
// ─────────────────────────────────────────────────────────────────────────────

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
      height: 310,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            height: 255,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.darkBlue, Color(0xFF3D5A80)],
              ),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SquareIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    _SquareIconButton(
                      icon: isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      onTap: onFavorite,
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                // Kecamatan • Kota sebagai subtitle header (dari DB)
                if (vehicle.kecamatan.isNotEmpty || vehicle.kota.isNotEmpty)
                  Text(
                    '${vehicle.kecamatan} • ${vehicle.kota}',
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  vehicle.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.08,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 0,
            child: Container(
              height: 152,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: _ImageByType(image: vehicle.image),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widgets Helper
// ─────────────────────────────────────────────────────────────────────────────

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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.yellow,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: icon == Icons.arrow_back_rounded
              ? AppColors.darkBlue
              : AppColors.red,
          size: 21,
        ),
      ),
    );
  }
}

class _BadgeLabel extends StatelessWidget {
  final String label;
  const _BadgeLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          color: AppColors.darkBlue,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _IconRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: Color(0xFF657384),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageByType extends StatelessWidget {
  final String image;
  const _ImageByType({required this.image});

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        image.startsWith('http://') || image.startsWith('https://');
    if (isNetwork) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/pickup-removed.png', fit: BoxFit.cover),
      );
    }
    return Image.asset(image, fit: BoxFit.cover);
  }
}

class _SpecificationRow extends StatelessWidget {
  final String label;
  const _SpecificationRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.softBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: AppColors.darkBlue,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: AppColors.primary,
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}