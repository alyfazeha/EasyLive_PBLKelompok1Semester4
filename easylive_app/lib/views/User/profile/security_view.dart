import 'package:flutter/material.dart';

import '../../../controllers/user/security_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/user/profile/edit_profile_field.dart';

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  final controller = SecurityController();
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  void _submitChangePassword() {
    final success = controller.changePassword(
      current: currentPassController.text,
      newPass: newPassController.text,
      confirm: confirmPassController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diubah'),
          backgroundColor: Colors.green,
        ),
      );
      currentPassController.clear();
      newPassController.clear();
      confirmPassController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengubah password. Periksa kembali.'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.darkBlue, Color(0xFF3D5A80)],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(35),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shield_rounded,
                        color: AppColors.yellow,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.yellow.withOpacity(0.3),
                        AppColors.yellow.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.yellow.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.lock_outline_rounded,
                    size: 48,
                    color: AppColors.yellow,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Keamanan Akun',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Perbarui password untuk menjaga akun tetap aman.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkBlue.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ubah Password',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.darkBlue,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Gunakan minimal 6 karakter dengan kombinasi huruf dan angka.',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 18),
                        EditProfileField(
                          controller: currentPassController,
                          label: 'Password Saat Ini',
                          icon: Icons.lock_outline_rounded,
                          isPassword: true,
                        ),
                        const SizedBox(height: 14),
                        EditProfileField(
                          controller: newPassController,
                          label: 'Password Baru',
                          icon: Icons.lock_rounded,
                          isPassword: true,
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: newPassController,
                          builder: (context, value, child) {
                            if (value.text.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return _PasswordStrengthIndicator(
                              password: value.text,
                              controller: controller,
                            );
                          },
                        ),
                        const SizedBox(height: 14),
                        EditProfileField(
                          controller: confirmPassController,
                          label: 'Konfirmasi Password Baru',
                          icon: Icons.verified_user_outlined,
                          isPassword: true,
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: confirmPassController,
                          builder: (context, value, child) {
                            if (value.text.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return _PasswordMatchIndicator(
                              newPassword: newPassController.text,
                              confirmPassword: value.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _SecurityTipCard(),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _submitChangePassword,
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
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
    );
  }
}

class _SecurityTipCard extends StatelessWidget {
  const _SecurityTipCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.darkBlue.withOpacity(0.06)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: AppColors.darkBlue),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Jangan gunakan password yang sama dengan akun lain dan hindari membagikan kode login ke siapa pun.',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                color: Colors.black54,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final SecurityController controller;

  const _PasswordStrengthIndicator({
    required this.password,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final strength = controller.getPasswordStrength(password);
    final label = controller.getStrengthLabel(password);
    final color = controller.getStrengthColor(password);

    Color indicatorColor;
    switch (color) {
      case "red":
        indicatorColor = Colors.red;
        break;
      case "orange":
        indicatorColor = Colors.orange;
        break;
      case "yellow":
        indicatorColor = Colors.yellow.shade700;
        break;
      default:
        indicatorColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.softBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kekuatan Password: $label",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: indicatorColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "$strength%",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: indicatorColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: strength / 100,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(indicatorColor),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordMatchIndicator extends StatelessWidget {
  final String newPassword;
  final String confirmPassword;

  const _PasswordMatchIndicator({
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    final isMatch = newPassword == confirmPassword && newPassword.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMatch ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            isMatch ? Icons.check_circle_rounded : Icons.error_rounded,
            color: isMatch ? Colors.green : AppColors.red,
            size: 17,
          ),
          const SizedBox(width: 8),
          Text(
            isMatch ? "Password cocok" : "Password tidak cocok",
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: isMatch ? Colors.green : AppColors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
