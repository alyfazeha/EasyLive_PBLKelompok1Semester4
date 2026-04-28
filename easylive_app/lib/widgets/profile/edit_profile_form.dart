import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Image selected: ${image.name}')));
    }
  }

  void _save() {
    widget.controller.updateProfile(
      newName: nameController.text,
      newEmail: emailController.text,
      newRole: roleController.text,
      newPassword: passwordController.text,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Profile berhasil diupdate")));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// PROFILE PICTURE
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.yellow,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// PERSONAL INFORMATION HEADER
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Personal Information",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// INPUT FIELDS
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// BUTTON SAVE AT BOTTOM
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
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
