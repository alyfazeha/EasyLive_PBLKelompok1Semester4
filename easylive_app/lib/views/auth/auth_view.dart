import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/loginRegister/customInput.dart';
import '../../core/color.dart';

class AuthView extends StatefulWidget {
  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool isLogin = true;

  // controllers
  final emailController = TextEditingController();
  final passController = TextEditingController();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPassController = TextEditingController();

  /// ROLE
  String selectedRole = "User";

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPassController.dispose();
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
                  Text(
                    isLogin ? "Log In\nEasyLive" : "Register\nEasyLive",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _buildToggleSlider(),

                  const SizedBox(height: 20),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isLogin ? _buildLoginForm() : _buildRegisterForm(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// slider
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
                            color: isLogin ? Colors.white : Colors.white70,
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
                      },
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                            color: !isLogin ? Colors.white : Colors.white70,
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

  // LOGIN FORM
  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey("login"),
      children: [
        CustomTextField(
          label: "Email",
          hint: "Enter your email",
          controller: emailController,
        ),
        CustomTextField(
          label: "Password",
          hint: "Enter password",
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
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: const Text("Login"),
        ),

        const SizedBox(height: 20),

        GestureDetector(
          onTap: () {
            setState(() {
              isLogin = false;
            });
          },
          child: const Text(
            "Don't have an account? Register",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  /// REGISTER FORM
  Widget _buildRegisterForm() {
    return Column(
      key: const ValueKey("register"),
      children: [

        /// DROPDOWN ROLE
        DropdownButtonFormField<String>(
          value: selectedRole,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          items: const [
            DropdownMenuItem(value: "User", child: Text("User")),
            DropdownMenuItem(value: "Kos Owner", child: Text("Kos Owner")),
            DropdownMenuItem(value: "Owner Services", child: Text("Owner Services")),
          ],
          onChanged: (value) {
            setState(() {
              selectedRole = value!;
            });
          },
        ),

        const SizedBox(height: 15),

        CustomTextField(label: "Name", hint: "Enter name", controller: nameController),
        CustomTextField(label: "Phone", hint: "Enter phone", controller: phoneController),
        CustomTextField(label: "Email", hint: "Enter email", controller: emailController),
        CustomTextField(label: "Password", hint: "Enter password", isPassword: true, controller: passController),
        CustomTextField(label: "Confirm Password", hint: "Re-enter password", isPassword: true, controller: confirmPassController),

        const SizedBox(height: 25),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.background,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            bool success = AuthController.register(
              email: emailController.text,
              password: passController.text,
              confirmPassword: confirmPassController.text,
              name: nameController.text,
              phone: phoneController.text,
              role: selectedRole, // KIRIM ROLE
            );

            if (success) {
              setState(() {
                isLogin = true;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Invalid Input Data!")),
              );
            }
          },
          child: const Text("Register"),
        ),
      ],
    );
  }
}
