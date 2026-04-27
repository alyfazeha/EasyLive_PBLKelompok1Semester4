import 'package:flutter/material.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../core/color.dart';
import '../../widgets/profile/edit_profile_field.dart';

class EditProfileForm extends StatefulWidget {
  final EditProfileController controller;

  const EditProfileForm({super.key, required this.controller});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController roleController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.controller.name);
    emailController =
        TextEditingController(text: widget.controller.email);
    roleController =
        TextEditingController(text: widget.controller.role);
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _save() {
    widget.controller.updateProfile(
      newName: nameController.text,
      newEmail: emailController.text,
      newRole: roleController.text,
      newPassword: passwordController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile berhasil diupdate")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          EditProfileField(
            label: "Role",
            controller: roleController,
            icon: Icons.badge,
          ),
          const SizedBox(height: 15),

          EditProfileField(
            label: "Nama",
            controller: nameController,
            icon: Icons.person,
          ),
          const SizedBox(height: 15),

          EditProfileField(
            label: "Email",
            controller: emailController,
            icon: Icons.email,
          ),
          const SizedBox(height: 15),

          EditProfileField(
            label: "Password",
            controller: passwordController,
            icon: Icons.lock,
            isPassword: true,
          ),

          const SizedBox(height: 25),

          /// BUTTON SAVE
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Save Changes",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}