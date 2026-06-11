import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/color.dart';
import '../../../controllers/user/home_controller.dart';
import '../../../models/user/kos_model.dart';
import '../../../widgets/user/home/bottom_navbar.dart';

class JasaRouteView extends StatefulWidget {
  final KostModel kost;

  const JasaRouteView({super.key, required this.kost});

  @override
  State<JasaRouteView> createState() => _JasaRouteViewState();
}

class _JasaRouteViewState extends State<JasaRouteView> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _continueBooking() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mohon isi lokasi jemput dan tujuan',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          backgroundColor: AppColors.darkBlue,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/personal_info',
      arguments: {
        'kost': widget.kost,
        'isJasa': true,
        'fromLocation': from,
        'toLocation': to,
        'selectedDate': _selectedDate.toIso8601String(),
      },
    );
  }

  void _navigateBottomNav(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/history');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/booking');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = HomeController.getUserName();

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Header biru atas
            Column(
              children: [
                Container(
                  height: 225,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
                  decoration: const BoxDecoration(
                    color: AppColors.darkBlue,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(18),
                    ),
                  ),
                  child: _RouteHeader(userName: userName),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),

            // Route Card (input lokasi + tanggal)
            Positioned(
              left: 24,
              right: 24,
              top: 90,
              child: _RouteCard(
                fromController: _fromController,
                toController: _toController,
                selectedDate: _selectedDate,
                onDateChanged: (date) => setState(() => _selectedDate = date),
              ),
            ),

            // Tombol Next
            Positioned.fill(
              top: 390,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(48, 0, 48, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Periksa kembali sebelum melanjutkan ke pembayaran',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                        color: Color(0xFF5D6B7A),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 205,
                      height: 59,
                      child: ElevatedButton(
                        onPressed: _continueBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.yellow,
                          foregroundColor: AppColors.darkBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadowColor: Colors.black.withOpacity(0.22),
                          elevation: 8,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
        onTap: _navigateBottomNav,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────

class _RouteHeader extends StatelessWidget {
  final String userName;

  const _RouteHeader({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.yellow,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: AppColors.darkBlue,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Route Card (input + tanggal)
// ─────────────────────────────────────────────────────────────────────────────

class _RouteCard extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const _RouteCard({
    required this.fromController,
    required this.toController,
    required this.selectedDate,
    required this.onDateChanged,
  });

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input lokasi (tanpa ikon samping)
          _LocationInput(
            label: 'Dari',
            controller: fromController,
            hint: 'Masukkan lokasi jemput',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(thickness: 1, color: AppColors.darkBlue),
          ),
          _LocationInput(
            label: 'Ke',
            controller: toController,
            hint: 'Masukkan lokasi tujuan',
          ),

          const SizedBox(height: 25),

          // Bagian Departure & Tanggal
          const Text(
            'Tanggal Pindah',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              // Pilihan tanggal ±2 hari
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    final date = selectedDate.add(Duration(days: index - 2));
                    final isSelected =
                        date.year == selectedDate.year &&
                        date.month == selectedDate.month &&
                        date.day == selectedDate.day;
                    return GestureDetector(
                      onTap: () => onDateChanged(date),
                      child: Column(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFD1DDE6)
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${date.day}',
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat('E').format(date).toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 10,
                              color: isSelected ? Colors.black : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              // Garis pemisah
              Container(
                height: 40,
                width: 1.5,
                color: Colors.grey[300],
                margin: const EdgeInsets.symmetric(horizontal: 15),
              ),

              // Pilih bulan/tahun
              InkWell(
                onTap: () => _showDatePicker(context),
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          DateFormat('MMM')
                              .format(selectedDate)
                              .toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down,
                            color: Colors.amber),
                      ],
                    ),
                    Text(
                      DateFormat('yyyy').format(selectedDate),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget input lokasi
// ─────────────────────────────────────────────────────────────────────────────

class _LocationInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const _LocationInput({
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
          TextField(
            controller: controller,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.darkBlue,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13,
                color: Colors.black26,
                fontWeight: FontWeight.w500,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 4, bottom: 2),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}