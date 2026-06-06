import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileController extends ChangeNotifier {
  String name = '';
  String email = '';
  String role = '';
  String imagePath = '';

  // fields that edit_profile_view.dart expects
  String phone = '';
  String birthdate = '';
  String gender = '';
  String address = '';

  bool isLoading = false;

  final SupabaseClient _supabase = Supabase.instance.client;

  EditProfileController() {
    loadData();
  }

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        isLoading = false;
        notifyListeners();
        return;
      }

      final res = await _supabase
          .from('profiles')
          .select(
            'username, email, phone, full_name, birth_date, gender, address, photo, role',
          )
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

  void updateImage(String path) {
    imagePath = path;
    notifyListeners();
  }

  bool isValidEmail(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  String? validate({required String newName, required String newEmail}) {
    if (newName.trim().isEmpty) return 'Name cannot be empty';
    if (newEmail.trim().isEmpty) return 'Email cannot be empty';
    if (!isValidEmail(newEmail.trim())) return 'Invalid email format';
    return null;
  }

  Future<void> updateProfile({
    required String newName,
    required String newEmail,
    required String newPhone,
    required String newBirthdate,
    required String newGender,
    required String newAddress,
    String? newImagePath,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User tidak login');
      }

      String? photoUrl;

      // upload photo if any
      if (newImagePath != null && newImagePath.isNotEmpty) {
        final file = File(newImagePath);
        final fileName =
            'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await _supabase.storage
            .from('profile-images')
            .uploadBinary(
              fileName,
              await file.readAsBytes(),
              fileOptions: const FileOptions(contentType: 'image/*'),
            );

        photoUrl = _supabase.storage
            .from('profile-images')
            .getPublicUrl(fileName);
      }

      await _supabase
          .from('profiles')
          .update({
            'username': newName,
            'email': newEmail,
            'phone': newPhone,
            'birth_date': newBirthdate.isNotEmpty ? newBirthdate : null,
            'gender': newGender,
            'address': newAddress,
            if (photoUrl != null) 'photo': photoUrl,
          })
          .eq('id_profile', user.id);

      name = newName;
      email = newEmail;
      phone = newPhone;
      birthdate = newBirthdate;
      gender = newGender;
      address = newAddress;
      if (photoUrl != null) {
        imagePath = photoUrl;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error update profile: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
