import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/app_provider.dart';
import '../models/infographic.dart';
import 'viewer_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  Infographic? _featuredInfographic;
  bool _hasSelectedInitialFeatured = false;

  void _selectRandomFeatured(AppProvider provider) {
    final all = provider.allInfographics;
    if (all.isNotEmpty) {
      setState(() {
        _featuredInfographic = all[Random().nextInt(all.length)];
        _hasSelectedInitialFeatured = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Auto-select featured if not yet selected and data is available
        if (!_hasSelectedInitialFeatured && provider.allInfographics.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasSelectedInitialFeatured) {
              _selectRandomFeatured(provider);
            }
          });
        }

        final newest = provider.allInfographics.take(5).toList();

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async {
                await provider.refreshData();
                _selectRandomFeatured(provider);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // 1. Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Infographica",
                                style: Theme.of(context).textTheme.headlineLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Learn visually. Understand deeply.",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF74777F),
                                    ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _buildHeaderAction(Icons.search_rounded, () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
                              }),
                              const SizedBox(width: 12),
                              _buildHeaderAction(Icons.favorite_outline_rounded, () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
                              }),
                              const SizedBox(width: 12),
                              _buildHeaderAction(Icons.settings_outlined, () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  // 2. Featured Section
                  if (_featuredInfographic != null) ...[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: Row(
                          children: [
                            Icon(Icons.stars_rounded, color: Color(0xFF673AB7), size: 20),
                            SizedBox(width: 8),
                            Text(
                              "Featured",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF673AB7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: _buildFeaturedCard(_featuredInfographic!),
                      ),
                    ),
                  ],

                  // 3. What's New Section
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
                      child: Row(
                        children: [
                          Icon(Icons.explore_rounded, color: Color(0xFF1A1C1E), size: 20),
                          SizedBox(width: 8),
                          Text(
                            "What's New",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (newest.isEmpty)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: Text("No infographics available yet.")),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100), // Added bottom padding for nav bar
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildNewItemCard(newest[index]);
                          },
                          childCount: newest.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 22, color: const Color(0xFF1A1C1E)),
      ),
    );
  }

  Widget _buildFeaturedCard(Infographic item) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewerScreen(infographic: item))),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF673AB7).withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: item.imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                      )
                    : Image.asset(item.imageUrl, fit: BoxFit.cover),
              ),
              
              // Dark Gradient Overlay for Readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
              ),
              
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF673AB7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewerScreen(infographic: item))),
                      icon: const Icon(Icons.menu_book_rounded, size: 18),
                      label: const Text("View Infographic"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF673AB7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewItemCard(Infographic item) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ViewerScreen(infographic: item))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey[100],
                child: item.imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                      )
                    : Image.asset(item.imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1C1E)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category,
                    style: const TextStyle(color: Color(0xFF673AB7), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(color: const Color(0xFF44474E).withValues(alpha: 0.7), fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF74777F)),
                      const SizedBox(width: 4),
                      Text(
                        "Latest", 
                        style: TextStyle(color: const Color(0xFF74777F), fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
