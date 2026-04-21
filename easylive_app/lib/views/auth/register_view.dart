import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/loginRegister/customInput.dart';
import '../../core/color.dart';

class RegisterView extends StatefulWidget {
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  // CONTROLLER
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  // ROLE
  String selectedRole = "User";

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth > 400 ? 350 : screenWidth * 0.85,
            padding: EdgeInsets.all(screenWidth * 0.08),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "Register\nEasyLive",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 20),

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
                    DropdownMenuItem(value: "Pemilik Kos", child: Text("Pemilik Kos")),
                    DropdownMenuItem(value: "Pemilik Jasa", child: Text("Pemilik Jasa Ekspedisi")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),

                const SizedBox(height: 15),

                CustomTextField(
                  label: "Name",
                  hint: "Enter your name",
                  controller: nameController,
                ),
                CustomTextField(
                  label: "Phone",
                  hint: "Enter phone",
                  controller: phoneController,
                ),
                CustomTextField(
                  label: "Email",
                  hint: "Enter email",
                  controller: emailController,
                ),
                CustomTextField(
                  label: "Password",
                  hint: "Enter password",
                  isPassword: true,
                  controller: passController,
                ),
                CustomTextField(
                  label: "Confirm Password",
                  hint: "Re-enter password",
                  isPassword: true,
                  controller: confirmPassController,
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    bool success = AuthController.register(
                      email: emailController.text,
                      password: passController.text,
                      confirmPassword: confirmPassController.text,
                      name: nameController.text,
                      phone: phoneController.text,
                      role: selectedRole, 
                    );

                    if (success) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacementNamed(context, '/login');
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Data tidak valid!")),
                      );
                    }
                  },
                  child: const Text("Register"),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
