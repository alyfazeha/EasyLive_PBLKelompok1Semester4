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
  late TextEditingController phoneController;
  late TextEditingController birthdateController;
  late TextEditingController genderController;
  late TextEditingController addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.controller.name);
    emailController = TextEditingController(text: widget.controller.email);
    roleController = TextEditingController(text: widget.controller.role);
    passwordController = TextEditingController();
    phoneController = TextEditingController(text: widget.controller.phone);
    birthdateController = TextEditingController(
      text: widget.controller.birthdate,
    );
    genderController = TextEditingController(text: widget.controller.gender);
    addressController = TextEditingController(text: widget.controller.address);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    roleController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    genderController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // samakan field yang ada di register
    widget.controller.phone = phoneController.text;
    widget.controller.birthdate = birthdateController.text;
    widget.controller.gender = genderController.text;
    widget.controller.address = addressController.text;

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

    try {
      await widget.controller.updateProfile(
        newName: nameController.text,
        newEmail: emailController.text,
        newRole: roleController.text,
        newPassword: passwordController.text,
        newImagePath: widget.selectedImage?.path,
      );
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile berhasil diupdate"), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal update: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
              borderRadius: BorderRadius.circular(22),
              color: Colors.white,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppColors.secondary.withOpacity(0.32),
                  Colors.white,
                ],
              ),
              border: Border.all(
                color: AppColors.darkBlue.withOpacity(0.16),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkBlue.withOpacity(0.12),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: roleController.text.isEmpty
                          ? 'User'
                          : roleController.text,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primary,
                      ),
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'User', child: Text('User')),
                        DropdownMenuItem(
                          value: 'Pemilik Kos',
                          child: Text('Pemilik Kos'),
                        ),
                        DropdownMenuItem(
                          value: 'Pemilik Jasa',
                          child: Text('Pemilik Jasa'),
                        ),
                        DropdownMenuItem(
                          value: 'Admin Jasa',
                          child: Text('Admin Jasa'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          roleController.text = newValue;
                        });
                      },
                    ),
                  ),
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
                  label: "Phone",
                  controller: phoneController,
                  icon: Icons.phone_android_outlined,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: "Birthday (yyyy-MM-dd)",
                  controller: birthdateController,
                  icon: Icons.calendar_month_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: "Gender",
                  controller: genderController,
                  icon: Icons.transgender_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: "Address",
                  controller: addressController,
                  icon: Icons.location_on_outlined,
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
