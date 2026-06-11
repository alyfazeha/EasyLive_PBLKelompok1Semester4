import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../models/user/kos_model.dart';
import '../../../core/color.dart';
import '../../../widgets/user/payment/personal_info_widgets.dart';
import '../payment/invoice_view.dart';

class PersonalInfoView extends StatefulWidget {
  final KostModel kost;
  final bool isJasa;
  final String? fromLocation;
  final String? toLocation;

  const PersonalInfoView({
    super.key,
    required this.kost,
    this.isJasa = false,
    this.fromLocation,
    this.toLocation,
  });

  @override
  State<PersonalInfoView> createState() => _PersonalInfoViewState();
}

class _PersonalInfoViewState extends State<PersonalInfoView> {
  // Dikunci – hanya untuk menampilkan data dari Supabase
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Untuk kolom booking_kos.tanggal_checkin (hanya mode kost)
  DateTime? _selectedCheckinDate;

  bool _isAgreed = false;
  bool _isFormValid = false;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Ambil data profil user yang sedang login dari tabel `profiles`.
  Future<void> _loadUserProfile() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      setState(() => _isLoadingProfile = false);
      return;
    }

    try {
      final res = await supabase
          .from('profiles')
          .select('full_name, phone')
          .eq('id_profile', userId)
          .maybeSingle();

      if (res != null) {
        _nameController.text = (res['full_name'] ?? '').toString();
        _phoneController.text = (res['phone'] ?? '').toString();
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      setState(() => _isLoadingProfile = false);
      _checkValidation();
    }
  }

  void _checkValidation() {
    if (widget.isJasa) {
      setState(() {
        _isFormValid =
            _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _isAgreed;
      });
    } else {
      setState(() {
        _isFormValid =
            _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _selectedCheckinDate != null &&
            _isAgreed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const CustomHeader(),
          const PersonalStepper(),
          Expanded(
            child: _isLoadingProfile
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileSubHeader(),
                        const SizedBox(height: 25),

                        // Nama – dikunci, data dari Supabase
                        _buildLockedField(
                          widget.isJasa ? "Nama" : "Nama Lengkap",
                          Icons.person_outline,
                          _nameController,
                        ),
                        const SizedBox(height: 15),

                        // Nomor Telepon – dikunci, data dari Supabase
                        _buildLockedField(
                          "Nomor Telepon",
                          Icons.phone_android_outlined,
                          _phoneController,
                        ),

                        // Tanggal check-in (hanya mode kost)
                        if (!widget.isJasa) ...[
                          const SizedBox(height: 15),
                          _buildCheckinDatePicker(),
                        ],

                        // Rute dari–ke (hanya mode jasa, tanpa label jarak)
                        if (widget.isJasa &&
                            widget.fromLocation != null &&
                            widget.toLocation != null) ...[
                          const SizedBox(height: 30),
                          _buildRouteDisplay(),
                        ],

                        const SizedBox(height: 30),
                        _buildTerms(),
                      ],
                    ),
                  ),
          ),
          _buildFixedBottomArea(),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Field yang dikunci (read-only)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildLockedField(
    String label,
    IconData icon,
    TextEditingController controller,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        readOnly: true, // Dikunci – tidak bisa diedit
        style: const TextStyle(color: AppColors.primary),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, color: AppColors.primary),
          // Ikon kunci kecil di ujung kanan sebagai penanda visual
          suffixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Tampilan rute (tanpa label ~5 km)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildRouteDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFF2D3E50)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.fromLocation!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3E50),
                  ),
                ),
              ),
            ],
          ),
          // Garis penghubung sederhana menggantikan label jarak
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 11),
                Container(
                  width: 2,
                  height: 30,
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, color: Color(0xFFFBC02D)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.toLocation!,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3E50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Widget-widget lain (tidak berubah dari versi sebelumnya)
  // ──────────────────────────────────────────────────────────────────────────

  Widget _buildProfileSubHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.yellow,
          child: Icon(Icons.person, color: AppColors.primary, size: 30),
        ),
        const SizedBox(width: 15),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.yellow,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFixedBottomArea() {
    // Checkbox + tombol Payment — berlaku untuk kedua mode (jasa & kost)
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Checkbox(
                value: _isAgreed,
                onChanged: (v) {
                  setState(() => _isAgreed = v!);
                  _checkValidation();
                },
                activeColor: Colors.cyan,
              ),
              const Expanded(
                child: Text(
                  "Are you sure you want to proceed with the payment?",
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Rp ${widget.kost.price}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_isFormValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => InvoiceView(
                            kost: widget.kost,
                            isJasa: widget.isJasa, // <--- Kirim flag ini
      fromLocation: widget.fromLocation, // <--- Kirim alamat jemput
      toLocation: widget.toLocation, // <--- Kirim alamat tujuan
      jarakKm: 5.0, // <--- Sesuaikan dengan variabel jarak KM aktual kamu
                            namaPemesan: _nameController.text,
                            nomorHP: _phoneController.text,
            
                            tanggalCheckin: widget.isJasa ? null : _selectedCheckinDate,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Mohon lengkapi data dan centang persetujuan",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.primary,
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    "Payment",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckinDatePicker() {
    final theme = Theme.of(context);
    final formatted = _selectedCheckinDate == null
        ? 'Pilih tanggal'
        : '${_selectedCheckinDate!.day}/${_selectedCheckinDate!.month}/${_selectedCheckinDate!.year}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
        title: Text(
          formatted,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
        onTap: () async {
          final now = DateTime.now();
          final initial = _selectedCheckinDate ?? now;

          final picked = await showDatePicker(
            context: context,
            initialDate: initial,
            firstDate: DateTime(now.year - 1),
            lastDate: DateTime(now.year + 3),
          );

          if (picked == null) return;

          setState(() => _selectedCheckinDate = picked);
          _checkValidation();
        },
      ),
    );
  }

  Widget _buildTerms() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Terms and Conditions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "1. Penyewa can move into their new room immediately after payment",
          style: TextStyle(fontSize: 10),
        ),
        Text("2. Longest wait time: 3 months", style: TextStyle(fontSize: 10)),
        Text(
          "3. Cancellations are non-refundable",
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}