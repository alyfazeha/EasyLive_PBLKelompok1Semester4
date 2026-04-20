import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/loginRegister/customInput.dart';
import '../../core/color.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isLogin = true; //STATE SLIDER

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: screenWidth > 400 ? 350 : screenWidth * 0.85,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    "Log In\nEasyLive",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildToggleSlider(),

                  const SizedBox(height: 20),

                  CustomTextField(
                    label: "Email",
                    hint: "Enter your email address",
                    controller: emailController,
                  ),
                  CustomTextField(
                    label: "Password",
                    hint: "Enter your password",
                    isPassword: true,
                    controller: passController,
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.background,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();

                      bool isValid = AuthController.login(
                        emailController.text,
                        passController.text,
                      );

                      if (isValid) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, '/home');
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Email dan Password wajib diisi!"),
                          ),
                        );
                      }
                    },
                    child: const Text("Login"),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLogin = false;
                      });

                      Future.delayed(const Duration(milliseconds: 200), () {
                        Navigator.pushReplacementNamed(context, '/register');
                      });
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// FUNCTION SLIDER (SUDAH DIGABUNG)
  Widget _buildToggleSlider() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                left: isLogin ? 0 : constraints.maxWidth / 2,
                child: Container(
                  width: constraints.maxWidth / 2,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = true;
                        });
                      },
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color:
                                isLogin ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = false;
                        });

                        Future.delayed(
                            const Duration(milliseconds: 200), () {
                          Navigator.pushReplacementNamed(
                              context, '/register');
                        });
                      },
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color:
                                !isLogin ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}