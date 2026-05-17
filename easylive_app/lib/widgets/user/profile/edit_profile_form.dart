import 'dart:async';
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
    phoneController = TextEditingController(text: widget.controller.phone);
    birthdateController = TextEditingController(text: widget.controller.birthdate);
    genderController = TextEditingController(text: widget.controller.gender);
    addressController = TextEditingController(text: widget.controller.address);

    widget.controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!widget.controller.isLoading) {
      setState(() {
        nameController.text = widget.controller.name;
        emailController.text = widget.controller.email;
        phoneController.text = widget.controller.phone;
        birthdateController.text = widget.controller.birthdate;
        genderController.text = widget.controller.gender;
        addressController.text = widget.controller.address;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerUpdate);
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    genderController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final error = widget.controller.validate(
      newName: nameController.text,
      newEmail: emailController.text,
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    final updateError = await widget.controller.updateProfile(
      newName: nameController.text,
      newEmail: emailController.text,
      newPhone: phoneController.text,
      newBirthdate: birthdateController.text,
      newGender: genderController.text,
      newAddress: addressController.text,
      newImagePath: widget.selectedImage?.path, // ← path foto lokal
    );

    setState(() => _isLoading = false);

    if (updateError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(updateError), backgroundColor: Colors.red),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile berhasil diupdate'),
          backgroundColor: Colors.green,
        ),
      );
      if (mounted) Navigator.pop(context);
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
                  'Informasi Pribadi',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkBlue,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Lengkapi data akun agar profil kamu mudah dikenali.',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                EditProfileField(
                  label: 'Nama',
                  controller: nameController,
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: 'Email',
                  controller: emailController,
                  icon: Icons.email_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: 'Phone',
                  controller: phoneController,
                  icon: Icons.phone_android_outlined,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: 'Birthday (yyyy-MM-dd)',
                  controller: birthdateController,
                  icon: Icons.calendar_month_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: 'Gender',
                  controller: genderController,
                  icon: Icons.transgender_rounded,
                ),
                const SizedBox(height: 14),
                EditProfileField(
                  label: 'Address',
                  controller: addressController,
                  icon: Icons.location_on_outlined,
                ),
                // ← field password dihapus
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
                      'Save Changes',
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