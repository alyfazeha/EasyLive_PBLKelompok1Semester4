import 'package:flutter/foundation.dart';

class AdminNotificationSettingsController extends ChangeNotifier {
  bool _pushNotif = true;
  bool _emailNotif = false;
  bool _whatsappNotif = false;
  bool _onlyUnread = false;

  bool get pushNotif => _pushNotif;
  bool get emailNotif => _emailNotif;
  bool get whatsappNotif => _whatsappNotif;
  bool get onlyUnread => _onlyUnread;

  void togglePush(bool value) {
    _pushNotif = value;
    notifyListeners();
  }

  void toggleEmail(bool value) {
    _emailNotif = value;
    notifyListeners();
  }

  void toggleWhatsapp(bool value) {
    _whatsappNotif = value;
    notifyListeners();
  }

  void toggleOnlyUnread(bool value) {
    _onlyUnread = value;
    notifyListeners();
  }

  Future<void> save() async {
    // Placeholder: simpan ke Supabase/Storage jika sudah ada.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }
}

