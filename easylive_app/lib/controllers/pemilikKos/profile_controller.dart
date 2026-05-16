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

  static String getUserName() {
    return _userName.isNotEmpty ? _userName : 'Pemilik Kos';
  }

  static String getUserEmail() {
    return _userEmail.isNotEmpty ? _userEmail : '-';
  }

  static String getUserImage() {
    return _userImage.isNotEmpty
        ? _userImage
        : 'assets/images/logo-easylive.png';
  }

  static void logout() {
    _userName = '';
    _userEmail = '';
    _userImage = '';
  }
}
