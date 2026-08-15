import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/infographic.dart';
import '../providers/app_provider.dart';

class InfographicCard extends StatelessWidget {
  final Infographic infographic;
  final VoidCallback onTap;

  const InfographicCard({
    super.key,
    required this.infographic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final isFavorite = provider.isFavorite(infographic.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Hero(
                    tag: infographic.id,
                    child: Container(
                      color: const Color(0xFFF1F0F7),
                      child: infographic.imageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: infographic.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
                            )
                          : Image.asset(
                              infographic.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              infographic.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Color(0xFF1A1C1E),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => provider.toggleFavorite(infographic),
                            child: Icon(
                              isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              color: isFavorite ? Colors.red : const Color(0xFF74777F),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        infographic.category,
                        style: const TextStyle(
                          color: Color(0xFF673AB7),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
