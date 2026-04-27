import '../models/kos_model.dart';
import 'home_controller.dart';

class FavoriteController {

  /// ambil data favorit (sementara semua data dianggap favorit)
  static List<KostModel> getFavorites() {
    return HomeController.getKostList() ?? [];
  }
}