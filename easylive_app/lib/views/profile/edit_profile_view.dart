import 'package:flutter/material.dart';
import '../../core/color.dart';
import '../../widgets/profile/edit_profile_form.dart';
import '../../controllers/edit_profile_controller.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = EditProfileController();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.darkBlue,
      ),

      body: EditProfileForm(controller: controller),
    );
  }
}