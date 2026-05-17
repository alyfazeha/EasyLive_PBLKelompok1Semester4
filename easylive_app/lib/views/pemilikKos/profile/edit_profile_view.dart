import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/user/edit_profile_controller.dart';
import '../../../core/color.dart';
import '../../../widgets/user/profile/edit_profile_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late EditProfileController controller;
  XFile? selectedImage;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController birthdateController;
  late TextEditingController genderController;
  late TextEditingController addressController;
  late TextEditingController passwordController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = EditProfileController();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    birthdateController = TextEditingController();
    genderController = TextEditingController();
    addressController = TextEditingController();
    passwordController = TextEditingController();

    controller.addListener(() {
      if (!controller.isLoading) {
        setState(() {
          nameController.text = controller.name;
          emailController.text = controller.email;
          phoneController.text = controller.phone;
          birthdateController.text = controller.birthdate;
          genderController.text = controller.gender;
          addressController.text = controller.address;
        });
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthdateController.dispose();
    genderController.dispose();
    addressController.dispose();
    passwordController.dispose();
    controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => selectedImage = image);
    controller.updateImage(image.path);
  }

  Future<void> _save() async {
    final error = controller.validate(
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

    final updateError = await controller.updateProfile(
      newName: nameController.text,
      newEmail: emailController.text,
      newPhone: phoneController.text,
      newBirthdate: birthdateController.text,
      newGender: genderController.text,
      newAddress: addressController.text,
      newImagePath: selectedImage?.path,
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
    // Tentukan foto yang ditampilkan
    ImageProvider? photoProvider;
    if (selectedImage != null) {
      photoProvider = FileImage(File(selectedImage!.path));
    } else if (controller.imagePath.isNotEmpty &&
        controller.imagePath.startsWith('http')) {
      photoProvider = NetworkImage(controller.imagePath);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.darkBlue, Color(0xFF3D5A80)],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.yellow, Color(0xFFFFD141)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.yellow.withOpacity(0.35),
                                  blurRadius: 18,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.white,
                              backgroundImage: photoProvider,
                              // ← fallback ke asset jika tidak ada foto
                              child: photoProvider == null
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 52,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),
                          ),
                          Material(
                            color: AppColors.yellow,
                            shape: const CircleBorder(),
                            elevation: 3,
                            child: InkWell(
                              onTap: _pickImage,
                              customBorder: const CircleBorder(),
                              child: Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Perbarui informasi profil Anda',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
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
                                // ← dropdown role dihapus
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
                                const SizedBox(height: 14),
                                EditProfileField(
                                  label: 'Password baru (opsional)',
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
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
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}