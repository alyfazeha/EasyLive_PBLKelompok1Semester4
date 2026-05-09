import 'package:flutter/material.dart';

import 'input_field.dart';

class RegisterExtraFields extends StatelessWidget {
  const RegisterExtraFields({
    super.key,
    required this.phoneController,
    required this.birthdateController,
    required this.genderController,
    required this.addressController,
  });

  final TextEditingController phoneController;
  final TextEditingController birthdateController;
  final TextEditingController genderController;
  final TextEditingController addressController;

  static const double fieldSpacing = 12;

  Future<void> _pickBirthday(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1950),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E4052),
              onPrimary: Colors.white,
              onSurface: Color(0xFF2E4052),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) return;

    birthdateController.text =
        '${selectedDate.year.toString().padLeft(4, '0')}-'
        '${selectedDate.month.toString().padLeft(2, '0')}-'
        '${selectedDate.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthInputField(
          controller: phoneController,
          hintText: 'Phone',
          icon: Icons.phone_android_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: fieldSpacing),
        GestureDetector(
          onTap: () => _pickBirthday(context),
          child: AbsorbPointer(
            child: AuthInputField(
              controller: birthdateController,
              hintText: 'Birthday',
              icon: Icons.calendar_month_rounded,
              keyboardType: TextInputType.datetime,
            ),
          ),
        ),
        const SizedBox(height: fieldSpacing),
        AuthInputField(
          controller: genderController,
          hintText: 'Gender',
          icon: Icons.transgender_rounded,
        ),
        const SizedBox(height: fieldSpacing),
        AuthInputField(
          controller: addressController,
          hintText: 'Address',
          icon: Icons.location_on_outlined,
          keyboardType: TextInputType.streetAddress,
        ),
      ],
    );
  }
}
