import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/infographic_card.dart';
import 'viewer_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favorites"),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.favorite_border_rounded, size: 64, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "No favorites yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1C1E)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Items you love will appear here.",
                    style: TextStyle(color: Color(0xFF74777F)),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: provider.favorites.length,
            itemBuilder: (context, index) {
              final infographic = provider.favorites[index];
              return InfographicCard(
                infographic: infographic,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewerScreen(infographic: infographic),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
