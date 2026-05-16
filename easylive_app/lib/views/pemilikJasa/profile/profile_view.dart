import 'package:flutter/material.dart';

import '../../../../core/color.dart';
import '../../../../controllers/user/profile_controller.dart';
import '../../../../widgets/pemilikJasa/home/bottom_navbar.dart';

class PemilikJasaProfileView extends StatefulWidget {
  const PemilikJasaProfileView({super.key});

  @override
  State<PemilikJasaProfileView> createState() => _PemilikJasaProfileViewState();
}

class _PemilikJasaProfileViewState extends State<PemilikJasaProfileView> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();

  // Screenshot fields (isi placeholder kalau data belum ada)
  final _phoneController = TextEditingController(text: '081234567890');
  final _roleController = TextEditingController(text: 'Pemilik Jasa');
  final _addressController = TextEditingController(
    text: 'Jl. Merdeka No. 10, Jakarta, Indonesia',
  );
  final _bioController = TextEditingController(
    text: 'Administrator of Jasa Management System',
  );

  @override
  void initState() {
    super.initState();
    _fullNameController.text = ProfileController.getUserName();
    _emailController.text = ProfileController.getUserEmail();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ProfileController.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: SafeArea(
        top: false,
        child: PemilikJasaBottomNav(
          currentIndex: 4,
          onNavigate: (index) {
            if (index == 4) return; // tetap di profile
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/pemilik_jasa/dashboard');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/pemilik_jasa');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/pemilik_jasa/booking');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/pemilik_jasa/detail_jasa');
                break;
              default:
                break;
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top header like screenshot (no back/title here)
            SizedBox(
              height: 58,
              width: double.infinity,
              child: Container(
                color: AppColors.darkBlue,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    // left spacer (tidak ada tombol, hanya menyeimbangkan layout)
                    const SizedBox(width: 40),
                    const Expanded(
                      child: Text(
                        'Admin Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Notifikasi (demo)')),
                        );
                      },
                      icon: const Icon(Icons.notifications_active_outlined,
                          color: AppColors.background),
                      tooltip: 'Notifikasi',
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card header (back + title)
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: AppColors.darkBlue,
                              ),
                              tooltip: 'Back',
                            ),
                            const SizedBox(width: 4),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Profile Information',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Update your personal information',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _InfoField(
                          label: 'Full Name',
                          controller: _fullNameController,
                          icon: Icons.person,
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),

                        _InfoField(
                          label: 'Email Address',
                          controller: _emailController,
                          icon: Icons.email_outlined,
                          readOnly: true,
                        ),

                        _PillInfoField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          icon: Icons.phone_outlined,
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),

                        _DropdownLikeField(
                          label: 'Role',
                          controller: _roleController,
                          icon: Icons.verified_user_outlined,
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),

                        _PillInfoField(
                          label: 'Address',
                          controller: _addressController,
                          icon: Icons.location_on_outlined,
                          readOnly: true,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),

                        _BioField(
                          label: 'Bio',
                          controller: _bioController,
                          icon: Icons.edit_note_rounded,
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Saved (demo)')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              foregroundColor: AppColors.darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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


class _InfoField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool readOnly;
  final int maxLines;

  const _InfoField({
    required this.label,
    required this.icon,
    required this.controller,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: maxLines > 1 ? 36 : 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF6BE00).withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF243447)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: controller,
                  readOnly: readOnly,
                  maxLines: maxLines,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF243447),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PillInfoField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool readOnly;
  final int maxLines;

  const _PillInfoField({
    required this.label,
    required this.icon,
    required this.controller,
    this.readOnly = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF6BE00).withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF243447)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6BE00).withOpacity(0.09),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8EEF5)),
                  ),
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    maxLines: maxLines,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF243447),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownLikeField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final bool readOnly;

  const _DropdownLikeField({
    required this.label,
    required this.icon,
    required this.controller,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF6BE00).withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF243447)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6BE00).withOpacity(0.09),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE8EEF5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          readOnly: readOnly,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF243447),
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Color(0xFF243447)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BioField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;

  const _BioField({
    required this.label,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EEF5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF6BE00).withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF243447)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: controller,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF243447),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
