import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/infographic.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class AppProvider with ChangeNotifier {
  final DataService _dataService = DataService();
  final StorageService _storageService = StorageService();

  List<InfographicCategory> _categories = [];
  List<InfographicCategory> _dataStats = [];
  List<Infographic> _favorites = [];
  bool _isDarkMode = false;
  bool _isLoading = true;

  List<InfographicCategory> get categories => _categories;
  List<InfographicCategory> get dataStats => _dataStats;
  List<Infographic> get favorites => _favorites;
  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  List<Infographic> get allInfographics {
    final all = _categories.expand((c) => c.infographics).toList();
    // For now, just reverse to show "latest" (assuming tree order)
    return all.reversed.toList();
  }

  AppProvider() {
    _init();
  }

  Future<void> _init() async {
    _isDarkMode = await _storageService.getThemeMode();
    await refreshData();
  }

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _dataService.fetchCategories();
      _dataStats = await _dataService.fetchDataStats();
      _favorites = await _storageService.getFavorites();

      // Check for new infographics
      final currentAll = allInfographics;
      if (currentAll.isNotEmpty) {
        final newestId = currentAll.first.id;
        final lastSeenId = await _storageService.getLastSeenId();

        if (lastSeenId != null && lastSeenId != newestId) {
          // New infographic found!
          await NotificationService.showNotification(
            id: 1,
            title: "New Infographic Available!",
            body: "Check out: ${currentAll.first.title}",
          );
        }
        
        // Update last seen ID
        await _storageService.setLastSeenId(newestId);
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storageService.setThemeMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> toggleFavorite(Infographic infographic) async {
    final isFav = _favorites.any((e) => e.id == infographic.id);
    if (isFav) {
      await _storageService.removeFavorite(infographic.id);
      _favorites.removeWhere((e) => e.id == infographic.id);
    } else {
      await _storageService.saveFavorite(infographic);
      _favorites.add(infographic);
    }
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((e) => e.id == id);
  }

  List<Infographic> searchInfographics(String query) {
    if (query.isEmpty) return [];
    
    final all = _categories.expand((c) => c.infographics).toList();
    return all.where((i) => 
      i.title.toLowerCase().contains(query.toLowerCase()) ||
      i.category.toLowerCase().contains(query.toLowerCase()) ||
      i.description.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
