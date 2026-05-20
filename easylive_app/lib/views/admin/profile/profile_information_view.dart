import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminProfileInformationView extends StatefulWidget {
  const AdminProfileInformationView({super.key});

  @override
  State<AdminProfileInformationView> createState() =>
      _AdminProfileInformationViewState();
}

class _AdminProfileInformationViewState
    extends State<AdminProfileInformationView> {
  static const _navy = Color(0xFF243447);
  static const _yellow = Color(0xFFF6BE00);

  final _fullNameController = TextEditingController(text: 'Budi Santoso');
  final _emailController = TextEditingController(text: 'admin@easyjasa.com');
  final _phoneController = TextEditingController(text: '0821 4373 888789');

  final _roleOptions = const ['Super Admin', 'Admin Jasa', 'Admin Kos'];
  String _roleValue = 'Super Admin';

  final _addressController = TextEditingController(
    text: 'Jl. Merdeka No. 10, Jakarta, Indonesia',
  );

  final _bioController = TextEditingController(
    text: 'Administrator of Kost & Jasa Management System',
  );

  final _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();
  File? _pickedProfilePhoto;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePhoto(ImageSource source) async {
    try {
      final result = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (result == null) return;

      setState(() {
        _pickedProfilePhoto = File(result.path);
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memilih foto profile')),
      );
    }
  }

  Future<void> _onSaveChanges() async {
    final formState = _formKey.currentState;
    if (formState == null) return;

    if (!formState.validate()) return;

    final hasPhoto = _pickedProfilePhoto != null;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hasPhoto
              ? 'Profil berhasil diperbarui (foto profile diperbarui)'
              : 'Profil berhasil diperbarui',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profilePhoto = _pickedProfilePhoto;
    final initials = 'BS';

    return Scaffold(
      backgroundColor: Colors.white,
      body: ColoredBox(
        color: _navy,
        child: SafeArea(
          child: Column(
            children: [
              // Top app bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: _navy,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Profile Information',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 44), // spacer for bell
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 6),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      const Text(
                        'Update your personal information',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Photo preview
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color(0xFFF2F2F2),
                              border: Border.all(
                                color: Colors.black.withOpacity(0.08),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: profilePhoto != null
                                  ? Image.file(profilePhoto, fit: BoxFit.cover)
                                  : Center(
                                      child: Text(
                                        initials,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: _navy,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Foto Profile',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () => _pickProfilePhoto(
                                        ImageSource.gallery,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: _navy,
                                        side: BorderSide(
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Tambah Foto Profile',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    if (_pickedProfilePhoto != null)
                                      IconButton(
                                        tooltip: 'Hapus foto',
                                        onPressed: () {
                                          setState(() {
                                            _pickedProfilePhoto = null;
                                          });
                                        },
                                        icon: const Icon(Icons.delete_outline),
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                  ],
                                ),
                                const Text(
                                  'Pilih dari galeri (atau gunakan kamera di device jika tersedia).',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              _ProfileField(
                                label: 'Full Name',
                                hintText: 'Full Name',
                                controller: _fullNameController,
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) {
                                    return 'Full Name wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _ProfileField(
                                label: 'Email Address',
                                hintText: 'Email Address',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) return 'Email wajib diisi';
                                  if (!value.contains('@')) {
                                    return 'Email tidak valid';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _ProfileField(
                                label: 'Phone Number',
                                hintText: 'Phone Number',
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) return 'Phone wajib diisi';
                                  if (value.length < 8) {
                                    return 'Phone terlalu pendek';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _RoleDropdown(
                                      label: 'Role',
                                      options: _roleOptions,
                                      value: _roleValue,
                                      onChanged: (newValue) {
                                        if (newValue == null) return;
                                        setState(() => _roleValue = newValue);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _ProfileField(
                                label: 'Address',
                                hintText: 'Address',
                                controller: _addressController,
                                maxLines: 3,
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) {
                                    return 'Address wajib diisi';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              _ProfileField(
                                label: 'Bio',
                                hintText: 'Bio',
                                controller: _bioController,
                                maxLines: 3,
                                validator: (v) {
                                  final value = (v ?? '').trim();
                                  if (value.isEmpty) return 'Bio wajib diisi';
                                  return null;
                                },
                              ),

                              const SizedBox(height: 18),

                              // Save button
                              SizedBox(
                                height: 44,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _yellow,
                                    foregroundColor: _navy,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: _onSaveChanges,
                                  child: const Text(
                                    'Save Changes',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _ProfileField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Color(0xFF243447),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.22)),
            ),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
          ),
        ),
      ],
    );
  }
}

class _RoleDropdown extends StatelessWidget {
  final String label;
  final List<String> options;
  final String value;
  final ValueChanged<String?> onChanged;

  const _RoleDropdown({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black.withOpacity(0.08)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: options
                  .map(
                    (opt) => DropdownMenuItem<String>(
                      value: opt,
                      child: Text(
                        opt,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF243447),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}