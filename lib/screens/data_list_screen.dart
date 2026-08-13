import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/infographic_card.dart';
import 'viewer_screen.dart';

class DataListScreen extends StatelessWidget {
  final InfographicCategory category;

  const DataListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: category.infographics.isEmpty
          ? const Center(child: Text("No data visuals found yet"))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
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
