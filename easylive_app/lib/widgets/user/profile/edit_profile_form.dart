import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/user/edit_profile_controller.dart';
import '../../../core/color.dart';
import 'edit_profile_field.dart';

class EditProfileForm extends StatefulWidget {
  final EditProfileController controller;
  final XFile? selectedImage;

  const EditProfileForm({
    super.key,
    required this.controller,
    this.selectedImage,
  });

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController roleController;
  late TextEditingController passwordController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.controller.name);
    emailController = TextEditingController(text: widget.controller.email);
    roleController = TextEditingController(text: widget.controller.role);
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
    final error = widget.controller.validate(
      newName: nameController.text,
      newEmail: emailController.text,
      newRole: roleController.text,
      newPassword: passwordController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    widget.controller.updateProfile(
      newName: nameController.text,
      newEmail: emailController.text,
      newRole: roleController.text,
      newPassword: passwordController.text,
      newImagePath: widget.selectedImage?.path,
    );

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile berhasil diupdate"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBlue.withOpacity(0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Informasi Pribadi",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Lengkapi data akun agar profil kamu mudah dikenali.",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                EditProfileField(
                  label: "Role",
                  controller: roleController,
                  icon: Icons.badge_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: "Nama",
                  controller: nameController,
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: "Email",
                  controller: emailController,
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: "Password baru (opsional)",
                  controller: passwordController,
                  icon: Icons.lock_rounded,
                  isPassword: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 2,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Montserrat',
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
