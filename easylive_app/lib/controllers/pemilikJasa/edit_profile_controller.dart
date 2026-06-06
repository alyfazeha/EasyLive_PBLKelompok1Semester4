import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/pemilikJasa/edit_profile_model.dart';

class PemilikJasaEditProfileController extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  String username = '';
  String email = '';
  String phone = '';
  String birthdate = '';
  String gender = '';
  String address = '';
  String imagePath = '';

  bool isLoading = false;

  PemilikJasaEditProfileController() {
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

      // Asumsi struktur tabel sama seperti EditProfileController user:
      // id_profile diisi dengan user.id
      final res = await _supabase
          .from('profiles')
          .select('username, email, phone, birth_date, gender, address, photo')
          .eq('id_profile', user.id)
          .single();

      username = (res['username'] ?? '') as String;
      email = (res['email'] ?? '') as String;
      phone = (res['phone'] ?? '') as String;
      birthdate = (res['birth_date'] ?? '') as String;
      gender = (res['gender'] ?? '') as String;
      address = (res['address'] ?? '') as String;
      imagePath = (res['photo'] ?? '') as String;
    } catch (e) {
      debugPrint('Error loading pemilik jasa edit profile: $e');
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

  String? validate({required String newUsername, required String newEmail}) {
    if (newUsername.trim().isEmpty) return 'Name cannot be empty';
    if (newEmail.trim().isEmpty) return 'Email cannot be empty';
    if (!isValidEmail(newEmail.trim())) return 'Invalid email format';
    return null;
  }

  Future<void> updateProfile({
    required String newUsername,
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
      if (user == null) throw Exception('User tidak login');

      String? photoUrl;

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
            'username': newUsername,
            'email': newEmail,
            'phone': newPhone,
            'birth_date': newBirthdate.isNotEmpty ? newBirthdate : null,
            'gender': newGender,
            'address': newAddress,
            if (photoUrl != null) 'photo': photoUrl,
          })
          .eq('id_profile', user.id);

      username = newUsername;
      email = newEmail;
      phone = newPhone;
      birthdate = newBirthdate;
      gender = newGender;
      address = newAddress;

      if (photoUrl != null) imagePath = photoUrl;
    } catch (e) {
      debugPrint('Error update pemilik jasa edit profile: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  PemilikJasaEditProfileModel toModel() {
    return PemilikJasaEditProfileModel(
      username: username,
      email: email,
      phone: phone,
      birthdate: birthdate,
      gender: gender,
      address: address,
      imagePath: imagePath,
    );
  }
}
