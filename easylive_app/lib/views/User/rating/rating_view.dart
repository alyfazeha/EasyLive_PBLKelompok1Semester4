import 'package:flutter/material.dart';

import '../../../controllers/user/rating_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/common/back_button_widget.dart';

class RatingView extends StatefulWidget {
  const RatingView({super.key});

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  final RatingController controller = RatingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 34, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRatingSection(),
                    const SizedBox(height: 34),
                    const Divider(color: Color(0xFFC7CCD1), thickness: 1),
                    const SizedBox(height: 34),
                    _buildReviewSection(),
                    const SizedBox(height: 28),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 28),
      decoration: const BoxDecoration(
        color: AppColors.darkBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          const BackButtonWidget(
            backgroundColor: AppColors.golden,
            iconColor: AppColors.darkBlue,
            size: 56,
            iconSize: 26,
            borderRadius: 12,
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Text(
              'Rating & Ulasan',
              style: TextStyle(
                color: AppColors.golden,
                fontFamily: 'Montserrat',
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rating',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Berikan penilaian untuk layanan ini',
          style: TextStyle(
            color: Color(0xFF5F6872),
            fontFamily: 'Montserrat',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            RatingController.maxRating,
            (index) => _buildStar(index + 1),
          ),
        ),
        const SizedBox(height: 30),
        Center(
          child: Column(
            children: [
              Text(
                controller.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontFamily: 'Montserrat',
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.ratingLabel,
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStar(int value) {
    final isSelected = value <= controller.rating;

    return Semantics(
      button: true,
      label: 'Rating $value',
      child: InkWell(
        borderRadius: BorderRadius.circular(36),
        onTap: () => setState(() => controller.updateRating(value)),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.star_rounded,
            size: 58,
            color: isSelected ? AppColors.golden : const Color(0xFFD6D6D6),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ulasan',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bagikan pengalamanmu menggunakan layanan ini',
          style: TextStyle(
            color: Color(0xFF5F6872),
            fontFamily: 'Montserrat',
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 260,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFC7CCD1), width: 1.2),
          ),
          child: Stack(
            children: [
              TextField(
                controller: controller.reviewController,
                maxLines: null,
                expands: true,
                maxLength: RatingController.maxReviewLength,
                textAlignVertical: TextAlignVertical.top,
                onChanged: (value) {
                  setState(() => controller.updateReview(value));
                },
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  hintText: 'Tulis ulasan kamu di sini...',
                  hintStyle: TextStyle(
                    color: Color(0xFF8B8F95),
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20, 22, 20, 44),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 18,
                child: Text(
                  '${controller.reviewLength}/${RatingController.maxReviewLength}',
                  style: const TextStyle(
                    color: Color(0xFF7A7F85),
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: controller.canSubmit ? _handleSubmit : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.golden,
          disabledBackgroundColor: AppColors.golden.withValues(alpha: 0.55),
          foregroundColor: AppColors.darkBlue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Kirim Ulasan',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    controller.submitReview();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ulasan berhasil disiapkan'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
