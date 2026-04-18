import 'package:flutter/material.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
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
            decoration: BoxDecoration(
              color: const Color(0xFFEAC793),
              borderRadius: BorderRadius.circular(20),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Center(
                  child: Text(
                    "Register\nEasyLive",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[900],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildField("Nama Lengkap", "Masukkan nama lengkap"),
                const SizedBox(height: 12),

                _buildField("Email", "Masukkan email"),
                const SizedBox(height: 12),

                _buildField("No Handphone", "Masukkan nomor HP"),
                const SizedBox(height: 12),

                _buildField("Password", "Masukkan password", isPassword: true),
                const SizedBox(height: 12),

                _buildField(
                  "Konfirmasi Password",
                  "Ulangi password",
                  isPassword: true,
                ),

                const SizedBox(height: 25),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD53E0F),
                      foregroundColor: const Color(0xFFEED9B9),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Register"),
                  ),
                ),

                const SizedBox(height: 15),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Sudah punya akun? Login",
                      style: TextStyle(
                        color: Color(0xFFD53E0F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        const SizedBox(height: 5),
        _buildInput(hint, isPassword: isPassword),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.brown,
        fontSize: 16,
      ),
    );
  }

  Widget _buildInput(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFEED9B9),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
