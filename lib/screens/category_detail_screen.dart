import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/infographic_card.dart';
import 'viewer_screen.dart';

class CategoryDetailScreen extends StatelessWidget {
  final InfographicCategory category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.transparent,
      ),
      body: category.infographics.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "No infographics here yet.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: category.infographics.length,
              itemBuilder: (context, index) {
                final infographic = category.infographics[index];
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
            ),
    );
  }
}
