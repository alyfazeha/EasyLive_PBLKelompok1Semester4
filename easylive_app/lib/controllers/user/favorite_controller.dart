import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user/kos_model.dart';
import '../../controllers/user/home_controller.dart';
import 'kos_controller.dart';

class FavoriteController {
  /// Menggunakan Set untuk menyimpan nama kos yang difavoritkan
  static final Set<String> _favoriteNames = {};
  static const String _favoritesKey = 'favorite_kost_names';
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFavorites();
  }

  /// Load favorites from SharedPreferences
  static Future<void> _loadFavorites() async {
    if (_prefs == null) return;
    final List<String>? savedFavorites = _prefs!.getStringList(_favoritesKey);
    if (savedFavorites != null) {
      _favoriteNames.clear();
      _favoriteNames.addAll(savedFavorites);
    }
  }

  /// Save favorites to SharedPreferences
  static Future<void> _saveFavorites() async {
    if (_prefs == null) return;
    await _prefs!.setStringList(_favoritesKey, _favoriteNames.toList());
  }

  /// Ambil semua kos yang difavoritkan
  static List<KostModel> getFavorites() {
    final allKost = <KostModel>[];
    allKost.addAll(KostController.getAllKost());
    allKost.addAll(HomeController.getKostList());
    final uniqueKost = {for (var kost in allKost) kost.name: kost}.values.toList();
    return uniqueKost.where((kost) => _favoriteNames.contains(kost.name)).toList();
  }

  /// Cek apakah kos tertentu difavoritkan
  static bool isFavorite(String kosName) {
    return _favoriteNames.contains(kosName);
  }

  /// Toggle status favorit
  static Future<void> toggleFavorite(String kosName) async {
    if (_favoriteNames.contains(kosName)) {
      _favoriteNames.remove(kosName);
      print("Removed from favorites: $kosName");
    } else {
      _favoriteNames.add(kosName);
      print("Added to favorites: $kosName");
    }
    await _saveFavorites();
  }

  /// Tambah ke favorit
  static Future<void> addFavorite(String kosName) async {
    _favoriteNames.add(kosName);
    print("Added to favorites: $kosName");
    await _saveFavorites();
  }

  /// Hapus dari favorit
  static Future<void> removeFavorite(String kosName) async {
    _favoriteNames.remove(kosName);
    print("Removed from favorites: $kosName");
    await _saveFavorites();
  }

  /// Clear semua favorit
  static Future<void> clearFavorites() async {
    _favoriteNames.clear();
    print("All favorites cleared");
    await _saveFavorites();
  }

  /// Ambil jumlah favorit
  static int get favoriteCount => _favoriteNames.length;
}
