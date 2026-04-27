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
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// LOGO ATAS
            const Text(
              'EasyLive',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.yellow,
              ),
            ),

            const SizedBox(height: 28),

            /// CONTAINER PUTIH
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 30),
                  child: Stack(
                    children: [
                      /// GAMBAR BACKGROUND (LEBIH GEPENG & PANJANG)
                      Positioned(
                        top: 55,
                        left: 0,
                        right: 0,
                        child: SizedBox(
                          height: 500,
                          child: Image.asset(
                            'assets/images/loginn.png',
                            fit: BoxFit.fitHeight,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),

                      /// CONTENT
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITLE
                          const Text(
                            "Let's get something",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "Good to see u back",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),

                          /// JARAK AGAR GAMBAR MEMANJANG
                          const SizedBox(height: 340),

                          /// USERNAME
                          AuthInputField(
                            controller: usernameController,
                            hintText: 'alyfazahra',
                            icon: Icons.person_outline_rounded,
                          ),

                          const SizedBox(height: 16),

                          /// PASSWORD
                          AuthInputField(
                            controller: passController,
                            hintText: '***********',
                            icon: Icons.lock_outline_rounded,
                            obscureText: true,
                          ),

                          const SizedBox(height: 18),

                          /// SAVE ACCOUNT
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey.shade300,
                                  onChanged: (value) {
                                    setState(() {
                                      saveAccount = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          /// BUTTON SIGN IN
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
                                  fontWeight: FontWeight.bold,
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
                                onTap: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: AppColors.yellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
