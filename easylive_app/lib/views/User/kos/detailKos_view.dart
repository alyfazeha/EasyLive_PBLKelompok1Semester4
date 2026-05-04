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
      backgroundColor: const Color(0xFF1F1F1F),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(color: AppColors.background),
                clipBehavior: Clip.antiAlias,
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
                              padding: const EdgeInsets.fromLTRB(22, 24, 17, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.kost.name.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.darkBlue,
                                      letterSpacing: 0,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    description,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: AppColors.primary,
                                      fontSize: 14,
                                      height: 1.08,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _formatPrice(price),
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSpecifications(
                                    specifications,
                                    availableRooms,
                                  ),
                                  const SizedBox(height: 24),
                                  _buildFacilitiesHeader(),
                                  const SizedBox(height: 18),
                                  _buildFacilities(facilities),
                                  const SizedBox(height: 26),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    final imagePath = widget.kost.detailImage ?? 'assets/images/kamarKos.jpg';
    final heroTag = 'kos_image_${widget.kost.name}';

    return DetailHeader(
      imagePath: imagePath,
      onBack: () => Navigator.pop(context),
      onFavorite: _toggleFavorite,
      isFavorite: _isFavorite,
      heroTag: heroTag,
    );
  }

  Widget _buildSpecifications(List<String> specifications, int availableRooms) {
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
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                specifications.isEmpty
                    ? 'No specifications listed'
                    : specifications.join('\n'),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: AppColors.primary,
                  fontSize: 13,
                  height: 1.08,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Available : $availableRooms Room',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: AppColors.primary,
                fontSize: 13,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFacilitiesHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 2),
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
        padding: const EdgeInsets.only(left: 6, right: 2, bottom: 8),
        itemCount: facilities.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => FacilityChip(label: facilities[index]),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 22, 18),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellow,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          elevation: 5,
          shadowColor: AppColors.black.withValues(alpha: 0.28),
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
