import 'package:flutter/material.dart';
import '../../../models/user/kos_model.dart';
import '../../../core/color.dart';
import '../../../widgets/user/payment/personal_info_widgets.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _detailBarangController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  bool _isAgreed = false;
  bool _isFormValid = false;

  void _checkValidation() {
    if (widget.isJasa) {
      setState(() {
        _isFormValid =
            _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _detailBarangController.text.isNotEmpty;
      });
    } else {
      setState(() {
        _isFormValid =
            _nameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _ktpController.text.isNotEmpty &&
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSubHeader(),
                  const SizedBox(height: 25),
                  _buildInputField(
                    widget.isJasa ? "Nama" : "Nama Lengkap",
                    Icons.person_outline,
                    _nameController,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    "Nomor Telefon",
                    Icons.phone_android_outlined,
                    _phoneController,
                    isPhone: true,
                  ),
                  const SizedBox(height: 15),
                  if (!widget.isJasa)
                    _buildInputField(
                      "Nomor KTP",
                      Icons.credit_card_outlined,
                      _ktpController,
                      isPhone: true,
                    ),
                  if (widget.isJasa) ...[
                    _buildInputField(
                      "Detail Barang",
                      Icons.inventory_2_outlined,
                      _detailBarangController,
                    ),
                    const SizedBox(height: 15),
                    _buildInputField(
                      "Catatan Tambahan",
                      Icons.notes_outlined,
                      _catatanController,
                    ),
                  ],
                  const SizedBox(height: 30),
                  if (widget.isJasa &&
                      widget.fromLocation != null &&
                      widget.toLocation != null)
                    _buildRouteEllipse(),
                  if (!widget.isJasa) _buildTerms(),
                ],
              ),
            ),
          ),
          _buildFixedBottomArea(),
        ],
      ),
    );
  }

  Widget _buildProfileSubHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.yellow,
          child: Icon(Icons.person, color: AppColors.primary, size: 30),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Profile",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.yellow,
              ),
            ),
            const Text(
              "Tell us about yourself",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField(
    String hint,
    IconData icon,
    TextEditingController controller, {
    bool isPhone = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: AppColors.primary, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        textInputAction: TextInputAction.next,
        onChanged: (_) => _checkValidation(),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 17),
        ),
      ),
    );
  }

  Widget _buildRouteEllipse() {
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
          const SizedBox(height: 10),
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                "~5 km",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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

  Widget _buildFixedBottomArea() {
    if (widget.isJasa) {
      return Container(
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
                    Navigator.pushNamed(
                      context,
                      '/invoice',
                      arguments: widget.kost,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Mohon lengkapi data terlebih dahulu"),
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
      );
    }

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
                      Navigator.pushNamed(
                        context,
                        '/invoice',
                        arguments: widget.kost,
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
