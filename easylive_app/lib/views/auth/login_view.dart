import 'package:flutter/material.dart';
import '../../core/color.dart'; // Pastikan path ini sesuai
import '../../widgets/auth/input_field.dart'; // Pastikan path ini sesuai

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final usernameController = TextEditingController();
  final passController = TextEditingController();
  bool saveAccount = false;

  @override
  void dispose() {
    usernameController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // #2D3E50 (Biru Tua)
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// LOGO HEADER
            const Text(
              'EasyLive',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: AppColors.yellow, // #FFD141 (Kuning)
              ),
            ),

            const SizedBox(height: 28),

            /// WHITE CONTAINER AREA
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                ),
                // Gunakan ClipRRect agar gambar yang naik tidak keluar lengkungan
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: [
                        /// 1. GAMBAR BACKGROUND (Dinaikkan agar Kaki Tersembunyi)
                        Positioned(
                          // --- PERUBAHAN DI SINI ---
                          // Menaikkan posisi gambar (top: -60).
                          // Kaki ilustrasi akan terpotong oleh lengkungan container putih.
                          top: -23,
                          left: -20,
                          right: -20,
                          child: Image.asset(
                            'assets/images/login-bg.png',
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),

                        /// 2. LAYER KONTEN (Teks & Field Input)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(28, 35, 28, 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Let's get something",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Good to see u back",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),

                              /// JARAK PRESISI (Menyesuaikan letak Field alyfazahra)
                              const SizedBox(height: 310),

                              /// INPUT USERNAME
                              AuthInputField(
                                controller: usernameController,
                                hintText: 'alyfazahra',
                                icon: Icons.person_outline_rounded,
                              ),

                              const SizedBox(height: 16),

                              /// INPUT PASSWORD
                              AuthInputField(
                                controller: passController,
                                hintText: '***********',
                                icon: Icons.lock_outline_rounded,
                                obscureText: true,
                              ),

                              const SizedBox(height: 18),

                              /// SAVE ACCOUNT SECTION
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Save ur account',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: Switch(
                                      value: saveAccount,
                                      activeColor: AppColors.yellow,
                                      activeTrackColor: const Color(0xFFFFE9A8),
                                      onChanged: (value) {
                                        setState(() {
                                          saveAccount = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 25),

                              /// SIGN IN BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.yellow,
                                    foregroundColor: AppColors.primary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/home',
                                    );
                                  },
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              /// FOOTER
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have account? ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/register',
                                    ),
                                    child: const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: AppColors.yellow,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
