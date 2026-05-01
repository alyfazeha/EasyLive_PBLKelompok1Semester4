import 'package:flutter/material.dart';

import '../../models/user_model.dart';

class ProfileController {
  /// 🔥 DATA USER (sementara dummy)
  static String getUserName() {
    return "Alyfa Zahra";
  }

  static String getUserEmail() {
    return "alyfa@email.com";
  }

  static String getUserImage() {
    return "assets/images/alyfa.jpeg";
  }

  /// 🔥 ACTIONS
  static void logout() {
    // nanti bisa hapus session / token
    print("User logout");
  }
}
