import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../core/color.dart';
import '../../widgets/auth/input_field.dart'; // Import widget baru

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passController = TextEditingController();
  bool saveAccount = false;
  String selectedRole = 'User';

  final List<String> roles = ['User', 'Pemilik Kos', 'Pemilik Jasa', 'Admin'];

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passController.dispose();
    super.dispose();
  }

  void _submitRegister() {
    FocusScope.of(context).unfocus();
    final success = AuthController.register(
      email: emailController.text,
      password: passController.text,
      confirmPassword: passController.text,
      name: usernameController.text,
      phone: '-',
      role: selectedRole,
    );

    if (success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Data belum valid.')));
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
                  const SizedBox(height: 12),
                  // Menggunakan AuthInputField yang sudah dipisah
                  AuthInputField(
                    controller: emailController,
                    hintText: 'alyfazeha@gmail.com',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  AuthInputField(
                    controller: usernameController,
                    hintText: 'alyfazahra',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  AuthInputField(
                    controller: passController,
                    hintText: '***********',
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  // Switch Save Account
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Save ur account',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Switch(
                        value: saveAccount,
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.yellow,
                        onChanged: (value) =>
                            setState(() => saveAccount = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
