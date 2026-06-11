import 'package:flutter/material.dart';

import '../../../controllers/user/history_controller.dart';
import '../../../models/user/history_model.dart';
import '../../../widgets/user/home/bottom_navbar.dart';
import '../../../core/color.dart';
import '../../../widgets/common/back_button_widget.dart';

class HistoryDetailView extends StatefulWidget {
  final HistoryItem item;

  const HistoryDetailView({super.key, required this.item});

  @override
  State<HistoryDetailView> createState() => _HistoryDetailViewState();
}

class _HistoryDetailViewState extends State<HistoryDetailView> {
  // ─── Review state ────────────────────────────────────────────────────────────
  bool _loadingReview = true;
  Map<String, dynamic>? _existingReview; // null = belum review

  int _selectedRating = 0;
  final TextEditingController _ulasanController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadExistingReview();
  }

  @override
  void dispose() {
    _ulasanController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingReview() async {
    final review = await HistoryController.fetchExistingReview(widget.item);
    if (mounted) {
      setState(() {
        _existingReview = review;
        _loadingReview = false;
      });
    }
  }

  Future<void> _submitReview() async {
    if (_selectedRating == 0) {
      _showSnack('Pilih rating terlebih dahulu', isError: true);
      return;
    }
    if (_ulasanController.text.trim().isEmpty) {
      _showSnack('Tulis ulasan terlebih dahulu', isError: true);
      return;
    }

    setState(() => _submitting = true);

    final success = await HistoryController.submitReview(
      item: widget.item,
      rating: _selectedRating,
      ulasan: _ulasanController.text,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (success) {
      // Reload review dari Supabase supaya UI langsung tampil "sudah review"
      await _loadExistingReview();
      _showSnack('Ulasan berhasil dikirim!');
    } else {
      _showSnack('Gagal mengirim ulasan. Coba lagi.', isError: true);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(25, 60, 25, 25),
              decoration: const BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Row(
                children: [
                  const BackButtonWidget(
                    backgroundColor: AppColors.golden,
                    iconColor: AppColors.darkBlue,
                    size: 44,
                    iconSize: 20,
                    borderRadius: 12,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Text(
                      'Detail History',
                      style: TextStyle(
                        color: AppColors.golden,
                        fontWeight: FontWeight.w900,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Kartu Detail ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.darkBlue),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfo('Customer', widget.item.customerName),
                              _buildInfo('Order', widget.item.ownerName),
                              _buildInfo(widget.item.type, widget.item.title),
                              _buildInfo(
                                'Date',
                                HistoryController.formatHistoryDate(
                                  widget.item.dateTime,
                                ),
                              ),
                              const Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.golden,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  widget.item.status,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Aksen biru kanan
                      Container(
                        width: 15,
                        decoration: const BoxDecoration(
                          color: AppColors.darkBlue,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Section Rating & Ulasan ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 30),
              child: _buildReviewSection(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNav(
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) return;
            if (index == 1) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            } else if (index == 2) {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/booking', (route) => false);
            }
          },
        ),
      ),
    );
  }

  // ─── Review Section ──────────────────────────────────────────────────────────

  Widget _buildReviewSection() {
    // Masih loading cek review
    if (_loadingReview) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(color: AppColors.darkBlue),
        ),
      );
    }

    // Sudah pernah review → tampilkan review yang ada
    if (_existingReview != null) {
      return _buildExistingReview(_existingReview!);
    }

    // Belum review → tampilkan form
    return _buildReviewForm();
  }

  /// Tampilan jika user sudah review
  Widget _buildExistingReview(Map<String, dynamic> review) {
    final rating = (review['rating'] as num?)?.toInt() ?? 0;
    final ulasan = review['ulasan'] as String? ?? '-';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.darkBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.green, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Ulasan Anda',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Bintang read-only
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                color: AppColors.golden,
                size: 28,
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            ulasan,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            'Terima kasih atas ulasan Anda!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Form rating + ulasan (hanya muncul jika belum review)
  Widget _buildReviewForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.darkBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Beri Rating & Ulasan',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Bagikan pengalaman Anda (hanya bisa 1 kali)',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 16),

          // ── Bintang interaktif ─────────────────────────────────────────
          Row(
            children: List.generate(5, (i) {
              final starIndex = i + 1;
              return GestureDetector(
                onTap: () => setState(() => _selectedRating = starIndex),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    starIndex <= _selectedRating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.golden,
                    size: 36,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // ── Text field ulasan ──────────────────────────────────────────
          TextField(
            controller: _ulasanController,
            maxLines: 4,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: 'Tulis ulasan Anda di sini...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.darkBlue.withValues(alpha: 0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: AppColors.darkBlue.withValues(alpha: 0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: AppColors.darkBlue, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Tombol kirim ───────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Kirim Ulasan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helper ──────────────────────────────────────────────────────────────────

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            const Expanded(child: Divider(color: AppColors.darkBlue)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 15),
      ],
    );
  }
}