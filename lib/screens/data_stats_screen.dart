import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/category_card.dart';
import 'data_list_screen.dart';

class DataStatsScreen extends StatelessWidget {
  const DataStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.dataStats.length < 2) {
          return const Center(child: Text("Data categories not found. Please check your GitHub assets."));
        }

        final india = provider.dataStats.firstWhere((c) => c.name.toLowerCase() == "india", orElse: () => provider.dataStats[0]);
        final world = provider.dataStats.firstWhere((c) => c.name.toLowerCase() == "world", orElse: () => provider.dataStats[1]);

        return RefreshIndicator(
          onRefresh: provider.refreshData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Choose a Region",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CategoryCard(
                      category: india,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DataListScreen(category: india),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CategoryCard(
                      category: world,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DataListScreen(category: world),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Icon(Icons.insights, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                "Visualized data and statistics. Updated regularly.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }
}
