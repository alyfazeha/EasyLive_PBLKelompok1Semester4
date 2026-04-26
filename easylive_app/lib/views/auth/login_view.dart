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
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Header Logo Tetap di Atas
          const Text(
            'EasyLive',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColors.yellow,
            ),
          ),
          const SizedBox(height: 25),
          // Container Putih yang melengkung ke atas
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 30, 28, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Let's get something",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text(
                        'Good to see u back',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Gambar Ilustrasi Tengah
                      Center(
                        child: Image.asset(
                          'assets/images/register.jpeg', 
                          height: MediaQuery.of(context).size.height * 0.35,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Input Fields
                      AuthInputField(
                        controller: usernameController,
                        hintText: 'alyfazahra',
                        icon: Icons.person_outline_rounded,
                        isOutlined: true,
                      ),
                      const SizedBox(height: 15),
                      AuthInputField(
                        controller: passController,
                        hintText: '***********',
                        icon: Icons.lock_outline_rounded,
                        obscureText: true,
                        isOutlined: true,
                      ),
                      const SizedBox(height: 10),
                      // Switch Save Account
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
                              onChanged: (value) =>
                                  setState(() => saveAccount = value),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Tombol Sign In Kuning Lengkung
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
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
                          const Text("Don't have account? ", style: TextStyle(color: Colors.grey)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}