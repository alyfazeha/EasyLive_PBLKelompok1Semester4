import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../widgets/auth/input_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passController = TextEditingController();
  bool saveAccount = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna biru gelap sebagai background Scaffold
      backgroundColor: AppColors.primary,
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
            // Container Putih Full Screen
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Let's get something",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Text(
                    'Good to see u back',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Gambar Ilustrasi (PASTIKAN PATH BENAR)
                  Center(
                    child: Image.asset(
                      'assets/images/register.jpeg', // Cek kembali nama filenya
                      height: 350,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Input Fields
                  AuthInputField(
                    controller: usernameController,
                    hintText: 'alyfazahra',
                    icon: Icons.person_outline_rounded,
                    isOutlined: true,
                  ),
                  const SizedBox(height: 12),
                  AuthInputField(
                    controller: passController,
                    hintText: '***********',
                    icon: Icons.lock_outline_rounded,
                    obscureText: true,
                  ),
                  const SizedBox(height: 14),
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
                        activeThumbColor: Colors.white,
                        activeTrackColor: AppColors.yellow,
                        onChanged: (value) =>
                            setState(() => saveAccount = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Tombol Sign In
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
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Footer Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have account? "),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.yellow,
                            fontWeight: FontWeight.bold,
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
