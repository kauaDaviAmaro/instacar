import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorite_ride_ids';

  static Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> addFavorite(String rideId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    if (!favorites.contains(rideId)) {
      favorites.add(rideId);
      await prefs.setStringList(_key, favorites);
    }
  }

  static Future<void> removeFavorite(String rideId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_key) ?? [];
    favorites.remove(rideId);
    await prefs.setStringList(_key, favorites);
  }

  static Future<bool> isFavorite(String rideId) async {
    final favorites = await getFavorites();
    return favorites.contains(rideId);
  }
}
