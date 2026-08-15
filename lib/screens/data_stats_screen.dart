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
        final india = provider.dataStats.firstWhere(
          (c) => c.name.toLowerCase() == "india", 
          orElse: () => provider.dataStats.isNotEmpty ? provider.dataStats[0] : provider.categories[0]
        );
        final world = provider.dataStats.firstWhere(
          (c) => c.name.toLowerCase() == "world", 
          orElse: () => provider.dataStats.length > 1 ? provider.dataStats[1] : provider.categories[0]
        );

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: provider.refreshData,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data & Stats",
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Global and regional insights.",
                          style: TextStyle(color: Color(0xFF74777F), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  if (provider.isLoading)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ))
                  else ...[
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
                    const SizedBox(height: 48),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.auto_graph_rounded, size: 64, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                            const SizedBox(height: 24),
                            const Text(
                              "Educational Data Visualizations",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              "Explore structured data and statistics from India and around the world, updated as new research is published.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xFF74777F), fontSize: 14, height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ]
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
