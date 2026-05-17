import 'package:flutter/foundation.dart';

import '../../../models/admin/app_settings_model.dart';

class AdminAppSettingsController extends ChangeNotifier {
  AdminAppSettingsModel _settings = AdminAppSettingsModel.initial();
  bool _isSaving = false;

  AdminAppSettingsModel get settings => _settings;
  bool get isSaving => _isSaving;

  void setDarkMode(bool value) {
    _settings = _settings.copyWith(darkMode: value);
    notifyListeners();
  }

  void setReduceAnimations(bool value) {
    _settings = _settings.copyWith(reduceAnimations: value);
    notifyListeners();
  }

  Future<void> save() async {
    _isSaving = true;
    notifyListeners();

    // TODO: Integrasikan ke Supabase jika diperlukan.
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _isSaving = false;
    notifyListeners();
  }
}

