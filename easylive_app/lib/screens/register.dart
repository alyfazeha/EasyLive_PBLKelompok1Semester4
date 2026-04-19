import 'package:flutter/material.dart';
import '../../widgets/loginRegister/customInput.dart';
import '../../data/mockDatabase.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFEED9B9),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth > 400 ? 350 : screenWidth * 0.85,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(color: const Color(0xFFEAC793), borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                const Text("Register\nEasyLive", textAlign: TextAlign.center, 
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))),
                const SizedBox(height: 20),
                _buildToggleSlider(),
                const SizedBox(height: 20),
                CustomTextField(label: "Nama", hint: "Nama Lengkap", controller: nameController),
                CustomTextField(label: "No HP", hint: "0812...", controller: phoneController),
                CustomTextField(label: "Email", hint: "email@mail.com", controller: emailController),
                CustomTextField(label: "Password", hint: "min 6 karakter", isPassword: true, controller: passController),
                CustomTextField(label: "Ulangi Password", hint: "konfirmasi", isPassword: true, controller: confirmPassController),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD53E0F), foregroundColor: Colors.white, shape: StadiumBorder()),
                  onPressed: () {
                    if (passController.text == confirmPassController.text && emailController.text.isNotEmpty) {
                      MockDatabase.addUser(emailController.text, passController.text, nameController.text, phoneController.text);
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data tidak valid!")));
                    }
                  },
                  child: const Text("Register"),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text("Already have an account? Login", style: TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.w500)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSlider() {
    return Container(
      height: 45, decoration: BoxDecoration(color: const Color(0xFFA1887F), borderRadius: BorderRadius.circular(30)),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(children: [
          AnimatedPositioned(duration: const Duration(milliseconds: 250), left: constraints.maxWidth / 2,
            child: Container(width: constraints.maxWidth / 2, height: 45, decoration: BoxDecoration(color: const Color(0xFFD53E0F), borderRadius: BorderRadius.circular(30)))),
          Row(children: [
            Expanded(child: GestureDetector(
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 50));
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Center(child: Text("Login", style: TextStyle(color: Colors.white70)))),
            ),
            const Expanded(child: Center(child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ]),
        ]);
      }),
    );
  }
}