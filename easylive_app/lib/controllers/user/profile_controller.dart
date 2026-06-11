import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController {
  static String _userName = '';
  static String _userEmail = '';
  static String _userImage = '';
  static String _fullName = '';

  // ─── Fetch dari Supabase ──────────────────────────────────────────────────

  /// Fetch profile user yang sedang login dari tabel `profiles`.
  /// Dipanggil di initState ProfileView.
  static Future<void> fetchUserProfile() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    final res = await supabase
        .from('profiles')
        .select('username, full_name, email, photo')
        .eq('id_profile', userId)
        .maybeSingle();

    if (res == null) return;

    final fullName = (res['full_name'] ?? '').toString().trim();
    final username = (res['username'] ?? '').toString().trim();

    _fullName = fullName;
    _userName = fullName.isNotEmpty ? fullName : username;
    _userEmail = (res['email'] ?? '').toString().trim();

    // Photo: generate public URL dari bucket profile-images
    final photoPath = (res['photo'] ?? '').toString().trim();
    if (photoPath.isNotEmpty) {
      try {
        if (photoPath.startsWith('http://') ||
            photoPath.startsWith('https://')) {
          _userImage = photoPath;
        } else {
          _userImage = supabase.storage
              .from('profile-images')
              .getPublicUrl(photoPath);
        }
      } catch (_) {
        _userImage = '';
      }
    } else {
      _userImage = '';
    }
  }

  // ─── Getters ──────────────────────────────────────────────────────────────

  static String getUserName() =>
      _userName.isNotEmpty ? _userName : 'User';

  static String getFullName() =>
      _fullName.isNotEmpty ? _fullName : _userName;

  static String getUserEmail() =>
      _userEmail.isNotEmpty ? _userEmail : '-';

  /// Kembalikan URL foto, atau path asset default jika kosong.
  static String getUserImage() =>
      _userImage.isNotEmpty ? _userImage : '';

  static bool hasPhoto() => _userImage.isNotEmpty;

  // ─── Setter (untuk kompatibilitas backward) ───────────────────────────────

  static void setUserData({
    required String username,
    required String email,
    String? imagePath,
  }) {
    _userName = username;
    _userEmail = email;
    _userImage = imagePath ?? '';
  }

  // ─── Logout ───────────────────────────────────────────────────────────────

  static Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    _userName = '';
    _userEmail = '';
    _userImage = '';
    _fullName = '';
  }
}