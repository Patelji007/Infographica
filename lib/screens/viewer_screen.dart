import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/infographic.dart';
import '../providers/app_provider.dart';

class ViewerScreen extends StatelessWidget {
  final Infographic infographic;

  const ViewerScreen({super.key, required this.infographic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text(infographic.title),
        actions: [
          Consumer<AppProvider>(
            builder: (context, provider, child) {
              final isFav = provider.isFavorite(infographic.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red : Colors.white,
                onPressed: () => provider.toggleFavorite(infographic),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          PhotoView(
            imageProvider: infographic.imageUrl.startsWith('http')
                ? CachedNetworkImageProvider(infographic.imageUrl)
                : AssetImage(infographic.imageUrl) as ImageProvider,
            heroAttributes: PhotoViewHeroAttributes(tag: infographic.id),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4.1,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    infographic.category,
                    style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    infographic.description,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
