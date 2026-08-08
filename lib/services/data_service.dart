import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class DataService {
  // Toggle this to fetch from GitHub
  static const bool _useRemote = false;
  static const String _remoteUrl = "https://raw.githubusercontent.com/username/repo/main/data.json";

  Future<List<InfographicCategory>> fetchCategories() async {
    try {
      String jsonString;
      
      if (_useRemote) {
        final response = await http.get(Uri.parse(_remoteUrl));
        if (response.statusCode == 200) {
          jsonString = response.body;
        } else {
          jsonString = await rootBundle.loadString('assets/data/infographics.json');
        }
      } else {
        jsonString = await rootBundle.loadString('assets/data/infographics.json');
      }

      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> categoriesJson = data['categories'] ?? [];
      return categoriesJson.map((json) => InfographicCategory.fromJson(json)).toList();
    } catch (e) {
      // Fallback to local if remote fails or other errors
      final jsonString = await rootBundle.loadString('assets/data/infographics.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> categoriesJson = data['categories'] ?? [];
      return categoriesJson.map((json) => InfographicCategory.fromJson(json)).toList();
    }
  }
}
