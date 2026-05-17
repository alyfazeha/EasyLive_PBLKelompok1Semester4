import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PemilikKosProfileController extends ChangeNotifier {
  String _userName = '';
  String _userEmail = '';
  String _userImage = '';
  String _role = '';
  bool isLoading = false;

  final supabase = Supabase.instance.client;

  String get userName => _userName.isNotEmpty ? _userName : 'Pemilik Kos';
  String get userEmail => _userEmail.isNotEmpty ? _userEmail : '-';
  String get userImage => _userImage.isNotEmpty ? _userImage : '';
  String get role => _role;

  PemilikKosProfileController() {
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
          .select('username, email, photo, role')
          .eq('id_profile', user.id)
          .single();

      _userName = res['username'] ?? '';
      _userEmail = res['email'] ?? '';
      _userImage = res['photo'] ?? '';
      _role = res['role'] ?? '';
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
    _userName = '';
    _userEmail = '';
    _userImage = '';
    _role = '';
    notifyListeners();
  }
}