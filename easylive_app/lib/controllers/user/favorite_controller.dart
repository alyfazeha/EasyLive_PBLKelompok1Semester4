import '../../models/user/kos_model.dart';
import 'kos_controller.dart';

class FavoriteController {
  /// Menggunakan Set untuk menyimpan nama kos yang difavoritkan
  static final Set<String> _favoriteNames = {};

  /// Ambil semua kos yang difavoritkan
  static List<KostModel> getFavorites() {
    final allKost = KostController.getAllKost();
    return allKost.where((kost) => _favoriteNames.contains(kost.name)).toList();
  }

  /// Cek apakah kos tertentu difavoritkan
  static bool isFavorite(String kosName) {
    return _favoriteNames.contains(kosName);
  }

  /// Toggle status favorit
  static void toggleFavorite(String kosName) {
    if (_favoriteNames.contains(kosName)) {
      _favoriteNames.remove(kosName);
      print("Removed from favorites: $kosName");
    } else {
      _favoriteNames.add(kosName);
      print("Added to favorites: $kosName");
    }
  }

  /// Tambah ke favorit
  static void addFavorite(String kosName) {
    _favoriteNames.add(kosName);
    print("Added to favorites: $kosName");
  }

  /// Hapus dari favorit
  static void removeFavorite(String kosName) {
    _favoriteNames.remove(kosName);
    print("Removed from favorites: $kosName");
  }

  /// Clear semua favorit
  static void clearFavorites() {
    _favoriteNames.clear();
    print("All favorites cleared");
  }

  /// Ambil jumlah favorit
  static int get favoriteCount => _favoriteNames.length;
}
