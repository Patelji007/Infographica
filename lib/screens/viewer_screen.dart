import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/infographic.dart';
import '../providers/app_provider.dart';

import 'full_screen_viewer.dart';

class ViewerScreen extends StatelessWidget {
  final Infographic infographic;

  const ViewerScreen({super.key, required this.infographic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(infographic.title),
        actions: [
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(infographic.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red : null,
                onPressed: () => provider.toggleFavorite(infographic),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Infographic Preview (Tappable for Full Screen)
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenViewer(infographic: infographic),
                ),
              ),
              child: Hero(
                tag: infographic.id,
                child: infographic.imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: infographic.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => const SizedBox(
                          height: 300,
                          child: Center(child: Icon(Icons.broken_image, size: 80)),
                        ),
                      )
                    : Image.asset(
                        infographic.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const SizedBox(
                          height: 300,
                          child: Center(child: Icon(Icons.broken_image, size: 80)),
                        ),
                      ),
              ),
            ),
            
            // Metadata Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      infographic.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    infographic.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    infographic.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                        ),
                  ),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
