import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ProfileController {
  static UserModel getUserProfile() {
    return UserModel(
      name: 'Ahmad Rafi Hamdi',
      email: 'hamdirafi310@gmail.com',
      password: '',
      phone: '081234567890',
      role: 'tenant',
    );
  }

  static List<Map<String, dynamic>> getProfileMenus() {
    return const [
      {
        'title': 'User Details',
        'icon': Icons.person_outline,
      },
      {
        'title': 'Payment',
        'icon': Icons.credit_card_outlined,
      },
      {
        'title': 'Logout',
        'icon': Icons.logout_rounded,
      },
    ];
  }
}
