import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/infographic.dart';

class DataService {
  static const String _repoOwner = "Patelji007";
  static const String _repoName = "Infographica";
  static const String _branch = "main";
  static const String _basePath = "assets/infographics";
  static const String _dataStatsPath = "assets/data";

  static const String _treeApiUrl = "https://api.github.com/repos/$_repoOwner/$_repoName/git/trees/$_branch?recursive=1";
  static const String _rawBaseUrl = "https://raw.githubusercontent.com/$_repoOwner/$_repoName/$_branch/$_basePath";
  static const String _rawStatsBaseUrl = "https://raw.githubusercontent.com/$_repoOwner/$_repoName/$_branch/$_dataStatsPath";

  static const String _metaCachePrefix = "meta_cache_";

  final List<Map<String, dynamic>> _categoryConfigs = [
    {"name": "Physics", "icon": "science", "color": "blue"},
    {"name": "Geography", "icon": "public", "color": "teal"},
    {"name": "Science", "icon": "biotech", "color": "green"},
    {"name": "Technology", "icon": "settings", "color": "indigo"},
    {"name": "Environment", "icon": "eco", "color": "green"},
    {"name": "Biology", "icon": "biotech", "color": "orange"},
    {"name": "Mathematics", "icon": "functions", "color": "purple"},
    {"name": "History", "icon": "history", "color": "brown"},
  ];

  Future<List<InfographicCategory>> fetchCategories() async {
    try {
      // 1. Fetch entire repository tree for discovery
      final treeResponse = await http.get(Uri.parse(_treeApiUrl));
      if (treeResponse.statusCode != 200) throw Exception("Failed to fetch tree: ${treeResponse.statusCode}");

      final treeData = json.decode(treeResponse.body);
      final List<dynamic> tree = treeData['tree'] ?? [];

      // 2. Parse tree into a structured map: category -> folder -> files
      Map<String, Map<String, Map<String, String>>> discovered = {};

      for (var node in tree) {
        final path = node['path'] as String;
        if (!path.startsWith(_basePath)) continue;

        final relativePath = path.substring(_basePath.length + (path == _basePath ? 0 : 1));
        if (relativePath.isEmpty) continue;

        final parts = relativePath.split('/');
        if (parts.length < 2) continue;

        final categoryFolder = parts[0].toLowerCase();
        final infographicFolder = parts[1];
        
        discovered.putIfAbsent(categoryFolder, () => {});
        discovered[categoryFolder]!.putIfAbsent(infographicFolder, () => {});

        if (parts.length == 3) {
          final fileName = parts[2];
          discovered[categoryFolder]![infographicFolder]![fileName] = node['sha'];
        }
      }

      final prefs = await SharedPreferences.getInstance();
      List<InfographicCategory> categories = [];

      // 3. Build categories and infographics
      for (var config in _categoryConfigs) {
        final categoryName = config['name'] as String;
        final folderName = categoryName.toLowerCase();
        final categoryInfographics = discovered[folderName] ?? {};

        List<Infographic> infographics = [];

        for (var entry in categoryInfographics.entries) {
          final infoFolderName = entry.key;
          final files = entry.value;

          // Look for supported image
          String? imageFileName;
          final supportedExtensions = ['.png', '.jpg', '.jpeg', '.webp'];
          for (var fileName in files.keys) {
            final lowerName = fileName.toLowerCase();
            if (lowerName.startsWith('infographic.') && supportedExtensions.any((ext) => lowerName.endsWith(ext))) {
              imageFileName = fileName;
              break;
            }
          }

          if (imageFileName == null || !files.containsKey('info.txt')) continue;

          // Use cache for metadata if info.txt SHA hasn't changed
          final infoSha = files['info.txt']!;
          final cacheKey = "$_metaCachePrefix$infoSha";
          final cachedMeta = prefs.getString(cacheKey);

          String title;
          String description;

          if (cachedMeta != null) {
            final decoded = json.decode(cachedMeta);
            title = decoded['title'] ?? "Untitled";
            description = decoded['description'] ?? "";
          } else {
            // Fetch info.txt content
            final rawUrl = "$_rawBaseUrl/$folderName/$infoFolderName/info.txt";
            final infoResponse = await http.get(Uri.parse(rawUrl));
            
            if (infoResponse.statusCode == 200) {
              final lines = infoResponse.body.split('\n');
              title = lines.isNotEmpty ? lines[0].trim() : "Untitled";
              description = lines.length > 1 ? lines[1].trim() : "";
              
              await prefs.setString(cacheKey, json.encode({
                'title': title,
                'description': description,
              }));
            } else {
              continue;
            }
          }

          infographics.add(Infographic(
            id: "${folderName}_$infoFolderName",
            title: title,
            category: categoryName,
            description: description,
            imageUrl: "$_rawBaseUrl/$folderName/$infoFolderName/$imageFileName",
          ));
        }

        categories.add(InfographicCategory(
          name: categoryName,
          iconName: config['icon'],
          colorName: config['color'],
          infographics: infographics,
        ));
      }

      return categories;
    } catch (e) {
      debugPrint("Discovery error: $e");
      return _fetchLocalFallback();
    }
  }

  Future<List<InfographicCategory>> fetchDataStats() async {
    try {
      final treeResponse = await http.get(Uri.parse(_treeApiUrl));
      if (treeResponse.statusCode != 200) return [];

      final treeData = json.decode(treeResponse.body);
      final List<dynamic> tree = treeData['tree'] ?? [];

      Map<String, List<Infographic>> statsMap = {
        "india": [],
        "world": [],
      };

      for (var node in tree) {
        final path = node['path'] as String;
        if (!path.startsWith(_dataStatsPath)) continue;

        final relativePath = path.substring(_dataStatsPath.length + (path == _dataStatsPath ? 0 : 1));
        if (relativePath.isEmpty) continue;

        final parts = relativePath.split('/');
        if (parts.length != 2) continue;

        final folder = parts[0].toLowerCase();
        if (folder != "india" && folder != "world") continue;

        final fileName = parts[1];
        if (!fileName.toLowerCase().endsWith(".png")) continue;

        final title = fileName.replaceAll(".png", "").replaceAll("_", " ");

        statsMap[folder]!.add(Infographic(
          id: "stat_${folder}_$fileName",
          title: title,
          category: folder == "india" ? "India" : "World",
          description: "",
          imageUrl: "$_rawStatsBaseUrl/$folder/$fileName",
        ));
      }

      return [
        InfographicCategory(
          name: "India",
          iconName: "public",
          colorName: "orange",
          infographics: statsMap["india"]!,
        ),
        InfographicCategory(
          name: "World",
          iconName: "public",
          colorName: "blue",
          infographics: statsMap["world"]!,
        ),
      ];
    } catch (e) {
      debugPrint("Fetch stats error: $e");
      return [];
    }
  }

  Future<List<InfographicCategory>> _fetchLocalFallback() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/infographics.json');
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> categoriesJson = data['categories'] ?? [];
      return categoriesJson.map((json) => InfographicCategory.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
