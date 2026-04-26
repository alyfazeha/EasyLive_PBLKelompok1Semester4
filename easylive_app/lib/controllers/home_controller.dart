import '../models/kos_model.dart';
import 'kos_controller.dart';

class HomeController {
  static List<KostModel> getKostList() {
    // Ambil dari KostController agar data selalu konsisten
    return KostController.getAllKost();
  }

  static String getUserName() {
    return "Alyfa";
  }
}
