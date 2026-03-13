import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/models/story_model.dart';
import 'package:instagram_feed/providers/feed_provider.dart';
import 'package:instagram_feed/providers/post_interaction_provider.dart';
import 'package:instagram_feed/services/post_repository.dart';
import 'package:instagram_feed/widgets/shimmer_feed.dart';
import 'package:instagram_feed/widgets/top_bar.dart';
import 'package:instagram_feed/widgets/story_tray.dart';
import 'package:instagram_feed/widgets/post_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instagram_feed/widgets/shimmer_post_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late Future<List<StoryModel>> _storiesFuture;

  @override
  void initState() {
    super.initState();
    _storiesFuture = PostRepository().fetchStories();

    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll > maxScroll - 600) {
        ref.read(feedNotifierProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedNotifierProvider);

    // Initialize interactions whenever posts change
    ref.listen<FeedState>(feedNotifierProvider, (prev, next) {
      if (next.posts.isNotEmpty) {
        ref.read(postInteractionProvider.notifier).initialize(next.posts);
      }
    });

    // Initialize on first build too
    if (feedState.posts.isNotEmpty) {
      // Use addPostFrameCallback to avoid modifying providers during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(postInteractionProvider.notifier).initialize(feedState.posts);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: SafeArea(child: TopBar()),
      ),
      body: feedState.isLoadingInitial
          ? const ShimmerFeed()
          : CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              cacheExtent: 1000,
              slivers: [
                // Stories
                SliverToBoxAdapter(
                  child: FutureBuilder<List<StoryModel>>(
                    future: _storiesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildShimmerStories();
                      }
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            StoryTray(stories: snapshot.data!),
                            Divider(height: 1, color: Colors.grey.shade200),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                // Posts
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == feedState.posts.length) {
                        if (feedState.isLoadingMore) {
                          return const Column(
                            children: [
                              ShimmerPostCard(),
                              ShimmerPostCard(),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      return PostCard(post: feedState.posts[index]);
                    },
                    childCount: feedState.posts.length + (feedState.isLoadingMore ? 1 : 0),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildShimmerStories() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 50,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
