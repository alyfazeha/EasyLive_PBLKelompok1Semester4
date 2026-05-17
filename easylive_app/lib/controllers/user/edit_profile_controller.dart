import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController extends ChangeNotifier {
  String name = '';
  String email = '';
  String role = '';
  String imagePath = '';
  String phone = '';
  String birthdate = '';
  String gender = '';
  String address = '';
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  EditProfileController() {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final res = await supabase
          .from('profiles')
          .select('username, email, phone, full_name, birth_date, gender, address, photo, role')
          .eq('id_profile', user.id)
          .single();

      name = res['username'] ?? '';
      email = res['email'] ?? '';
      phone = res['phone'] ?? '';
      birthdate = res['birth_date'] ?? '';
      gender = res['gender'] ?? '';
      address = res['address'] ?? '';
      imagePath = res['photo'] ?? '';
      role = res['role'] ?? '';
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? validate({
    required String newName,
    required String newEmail,
  }) {
    if (newName.isEmpty) return 'Name cannot be empty';
    if (newEmail.isEmpty) return 'Email cannot be empty';
    if (!isValidEmail(newEmail)) return 'Invalid email format';
    return null;
  }

  Future<String?> updateProfile({
    required String newName,
    required String newEmail,
    required String newPhone,
    required String newBirthdate,
    required String newGender,
    required String newAddress,
    String? newImagePath, // ← path file lokal
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return 'User tidak login';

      String? photoUrl;

      // ← Upload foto ke Supabase Storage jika ada foto baru
      if (newImagePath != null && newImagePath.isNotEmpty) {
        final file = File(newImagePath);
        final fileName = 'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await supabase.storage.from('profile-images').uploadBinary(
          fileName,
          await file.readAsBytes(),
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );

        photoUrl = supabase.storage
            .from('profile-images')
            .getPublicUrl(fileName);
      }

      await supabase.from('profiles').update({
        'username': newName,
        'phone': newPhone,
        'full_name': newName,
        'birth_date': newBirthdate.isNotEmpty ? newBirthdate : null,
        'gender': newGender,
        'address': newAddress,
        if (photoUrl != null) 'photo': photoUrl, // ← update foto jika ada
      }).eq('id_profile', user.id);

      name = newName;
      email = newEmail;
      phone = newPhone;
      birthdate = newBirthdate;
      gender = newGender;
      address = newAddress;
      if (photoUrl != null) imagePath = photoUrl;

      notifyListeners();
      return null;
    } catch (e) {
      debugPrint('Error update profile: $e');
      return e.toString();
    }
  }

  void updateImage(String path) {
    imagePath = path;
    notifyListeners();
  }
}