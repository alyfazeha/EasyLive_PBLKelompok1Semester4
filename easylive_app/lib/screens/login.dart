import 'package:flutter/material.dart';
import '../../widgets/loginRegister/customInput.dart';
import '../../data/mockDatabase.dart';
import '../../screens/homePage.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

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
                const Text("Log In\nEasyLive", textAlign: TextAlign.center, 
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF3E2723))),
                const SizedBox(height: 20),
                _buildToggleSlider(),
                const SizedBox(height: 20),
                CustomTextField(label: "Email", hint: "email@mail.com", controller: emailController),
                CustomTextField(label: "Password", hint: "password", isPassword: true, controller: passController),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD53E0F), foregroundColor: Colors.white, shape: StadiumBorder()),
                  onPressed: () {
                    if (MockDatabase.checkLogin(emailController.text, passController.text)) {
                      if (!mounted) return;
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Email atau Password Salah!"), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: const Text("Login"),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                  child: const Text("Don't have an account? Register", style: TextStyle(color: Color(0xFF3E2723), fontWeight: FontWeight.w500)),
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
          AnimatedPositioned(duration: const Duration(milliseconds: 250), left: 0,
            child: Container(width: constraints.maxWidth / 2, height: 45, decoration: BoxDecoration(color: const Color(0xFFD53E0F), borderRadius: BorderRadius.circular(30)))),
          Row(children: [
            const Expanded(child: Center(child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
            Expanded(child: GestureDetector(
              onTap: () async {
                await Future.delayed(const Duration(milliseconds: 50));
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: const Center(child: Text("Register", style: TextStyle(color: Colors.white70)))),
            ),
          ]),
        ]);
      }),
    );
  }
}