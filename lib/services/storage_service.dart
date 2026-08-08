import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/infographic.dart';

class StorageService {
  static const String _favoritesKey = 'favorites_v1';
  static const String _themeKey = 'is_dark_mode';

  Future<void> saveFavorite(Infographic infographic) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    if (!favorites.any((e) => e.id == infographic.id)) {
      favorites.add(infographic);
      final String encoded = json.encode(favorites.map((e) => e.toJson()).toList());
      await prefs.setString(_favoritesKey, encoded);
    }
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    favorites.removeWhere((e) => e.id == id);
    final String encoded = json.encode(favorites.map((e) => e.toJson()).toList());
    await prefs.setString(_favoritesKey, encoded);
  }

  Future<List<Infographic>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encoded = prefs.getString(_favoritesKey);
    
    if (encoded == null) return [];
    
    final List<dynamic> decoded = json.decode(encoded);
    return decoded.map((e) => Infographic.fromJson(e)).toList();
  }

  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((e) => e.id == id);
  }

  Future<void> setThemeMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
}
