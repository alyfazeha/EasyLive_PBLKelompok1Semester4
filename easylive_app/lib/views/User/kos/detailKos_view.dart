import 'package:flutter/material.dart';
import '../../../models/user/kos_model.dart';
import '../../../core/color.dart';
import '../../../widgets/user/kosPage/detail_kos_widgets.dart';
import '../payment/personalInfo_view.dart';

class DetailKosView extends StatefulWidget {
  final KostModel kost;
  const DetailKosView({super.key, required this.kost});

  @override
  State<DetailKosView> createState() => _DetailKosViewState();
}

class _DetailKosViewState extends State<DetailKosView> {
  bool _isFavorite = true;

  String _formatPrice(int price) {
    String priceStr = price.toString();
    String result = '';
    int count = 0;
    for (int i = priceStr.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        result = '.$result';
      }
      result = priceStr[i] + result;
      count++;
    }
    return 'Rp $result,-';
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _navigateToPersonalInfo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PersonalInfoView(kost: widget.kost, isJasa: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final specifications = widget.kost.specifications ?? [];
    final facilities = widget.kost.facilities ?? [];
    final availableRooms = widget.kost.availableRooms ?? 0;
    final price = widget.kost.price ?? 0;
    final description = widget.kost.description ?? "No description available";

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
                    _buildHeaderImage(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.kost.name,
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
                              _AvailabilityBadge(
                                availableRooms: availableRooms,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: AppColors.primary,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  widget.kost.address,
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
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 13,
                                  color: Color(0xFF657384),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _formatPrice(price),
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
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: AppColors.primary,
                              fontSize: 13,
                              height: 1.45,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSpecifications(specifications),
                          const SizedBox(height: 24),
                          _buildFacilitiesHeader(),
                          const SizedBox(height: 14),
                          _buildFacilities(facilities),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    final imagePath = widget.kost.detailImage ?? 'assets/images/kamarKos.jpg';
    final heroTag = 'kos_image_${widget.kost.name}';

    return _KosHeader(
      imagePath: imagePath,
      onBack: () => Navigator.pop(context),
      onFavorite: _toggleFavorite,
      isFavorite: _isFavorite,
      heroTag: heroTag,
      title: widget.kost.name,
    );
  }

  Widget _buildSpecifications(List<String> specifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Room Specifications',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: AppColors.darkBlue,
            height: 1,
          ),
        ),
        const SizedBox(height: 9),
        specifications.isEmpty
            ? const Text(
                'No specifications listed',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: AppColors.primary,
                  fontSize: 13,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Column(
                children: specifications
                    .map((specification) => _SpecificationRow(label: specification))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildFacilitiesHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            'Facility',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w900,
              fontSize: 20,
              color: AppColors.darkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilities(List<String> facilities) {
    if (facilities.isEmpty) {
      return const Text(
        'No facilities listed',
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: AppColors.primary,
          fontSize: 14,
        ),
      );
    }

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 2, bottom: 8),
        itemCount: facilities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => FacilityChip(label: facilities[index]),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          shadowColor: AppColors.black.withValues(alpha: 0.2),
        ),
        onPressed: _navigateToPersonalInfo,
        child: const Text(
          'Select Room',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: AppColors.darkBlue,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class _KosHeader extends StatelessWidget {
  final String imagePath;
  final String title;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final bool isFavorite;
  final String heroTag;

  const _KosHeader({
    required this.imagePath,
    required this.title,
    required this.onBack,
    required this.onFavorite,
    required this.isFavorite,
    required this.heroTag,
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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _SquareIconButton(
                      icon: Icons.arrow_back_rounded,
                      onTap: onBack,
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
                const Text(
                  'Kost Detail',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
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
              padding: const EdgeInsets.all(8),
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
                borderRadius: BorderRadius.circular(18),
                child: Hero(
                  tag: heroTag,
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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

class _AvailabilityBadge extends StatelessWidget {
  final int availableRooms;

  const _AvailabilityBadge({required this.availableRooms});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$availableRooms Room',
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
