import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/app_provider.dart';
import '../widgets/category_card.dart';
import 'category_detail_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: provider.refreshData,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Library",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Browse infographics by category.",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF74777F),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (provider.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final category = provider.categories[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 450),
                              columnCount: 2,
                              child: FadeInAnimation(
                                child: ScaleAnimation(
                                  child: CategoryCard(
                                    category: category,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CategoryDetailScreen(category: category),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: provider.categories.length,
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
}
