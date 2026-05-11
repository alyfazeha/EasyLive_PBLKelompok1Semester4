import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../core/color.dart';
import '../../widgets/auth/input_field.dart'; // Import widget baru
import '../../widgets/auth/register_extra_fields.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  static const double _fieldSpacing = 12;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passController = TextEditingController();

  // Extra fields
  final fullnameController = TextEditingController();
  final phoneController = TextEditingController();
  final birthdateController = TextEditingController();
  final genderController = TextEditingController();
  final addressController = TextEditingController();

  String selectedRole = 'User';

  final List<String> roles = [
    'User',
    'Pemilik Kos',
    'Pemilik Jasa',
    'Admin Jasa',
  ];

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passController.dispose();

    fullnameController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    genderController.dispose();
    addressController.dispose();

    super.dispose();
  }

  void _submitRegister() async {
    if (emailController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field harus diisi!'),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final messenger = ScaffoldMessenger.of(context);

    final result = await AuthController.register(
      email: emailController.text.trim(),
      password: passController.text,
      confirmPassword: passController.text,
      fullName: fullnameController.text.trim().isEmpty
          ? usernameController.text
          : fullnameController.text.trim(),
      username: usernameController.text,
      phone: phoneController.text.trim(),
      role: _mapRole(selectedRole),
      birthdate: birthdateController.text.trim(),
      gender: genderController.text.trim(),
      address: addressController.text.trim(),
    );

    if (!mounted) return;

    // TAMPILKAN NOTIFIKASI
    messenger.showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor:
            result['success'] ? Colors.green : Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );

    // JIKA REGISTER BERHASIL
    if (result['success'] == true) {

      // TUNGGU SNACKBAR
      await Future.delayed(const Duration(seconds: 2));

      // SELALU KE LOGIN
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  // Mapping role dropdown ke value di database
  String _mapRole(String role) {
    switch (role) {
      case 'User':
        return 'user';
      case 'Pemilik Kos':
        return 'kos';
      case 'Pemilik Jasa':
        return 'jasa';
      case 'Admin':
        return 'admin';
      default:
        return 'user';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Background biru full
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Header Logo
            const Text(
              'EasyLive',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 38,
                fontWeight: FontWeight.w700,
                color: AppColors.yellow,
              ),
            ),
            const SizedBox(height: 30),
            // Container Putih Full Width & Rounded Top
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(28, 30, 28, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Ilustrasi
                  Center(
                    child: Image.asset(
                      'assets/images/register.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Getting Started',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    'Create account to continue!',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Role Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primary,
                        ),
                        dropdownColor: Colors.white,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                        items: roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedRole = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: _fieldSpacing),
                  // Menggunakan AuthInputField yang sudah dipisah
                  AuthInputField(
                    controller: usernameController,
                    hintText: 'User Name',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  AuthInputField(
                    controller: fullnameController,
                    hintText: 'Full Name',
                    icon: Icons.account_circle_rounded,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  AuthInputField(
                    controller: emailController,
                    hintText: 'Email',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: _fieldSpacing),

                  // Extra form fields
                  RegisterExtraFields(
                    phoneController: phoneController,
                    birthdateController: birthdateController,
                    genderController: genderController,
                    addressController: addressController,
                  ),
                  const SizedBox(height: _fieldSpacing),
                  AuthInputField(
                    controller: passController,
                    hintText: 'Password',
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  // Tombol Sign Up
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _submitRegister,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Footer Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushReplacementNamed(context, '/login'),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
