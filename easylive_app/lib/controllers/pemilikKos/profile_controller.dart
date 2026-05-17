class PemilikKosProfileController {
  static String _userName = '';
  static String _userEmail = '';
  static String _userImage = '';

  static void setUserData({
    required String username,
    required String email,
    String? imagePath,
  }) {
    _userName = username;
    _userEmail = email;
    _userImage = imagePath ?? '';
  }

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