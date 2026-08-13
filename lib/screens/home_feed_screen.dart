import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/feed_card.dart';
import 'viewer_screen.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final infographics = provider.allInfographics;

        if (infographics.isEmpty) {
          return const Center(child: Text("No infographics found"));
        }

        return RefreshIndicator(
          onRefresh: provider.refreshData,
          child: ListView.builder(
            itemCount: infographics.length,
            itemBuilder: (context, index) {
              final infographic = infographics[index];
              return FeedCard(
                infographic: infographic,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewerScreen(infographic: infographic),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
