import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/models/post_model.dart';
import 'package:instagram_feed/services/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository();
});

class FeedState {
  final List<PostModel> posts;
  final bool isLoadingInitial;
  final bool isLoadingMore;
  final int currentPage;
  final bool hasMore;

  FeedState({
    required this.posts,
    this.isLoadingInitial = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.hasMore = true,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    bool? isLoadingInitial,
    bool? isLoadingMore,
    int? currentPage,
    bool? hasMore,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoadingInitial: isLoadingInitial ?? this.isLoadingInitial,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FeedNotifier extends StateNotifier<FeedState> {
  final PostRepository _postRepository;

  FeedNotifier(this._postRepository) : super(FeedState(posts: [])) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoadingInitial: true);
    try {
      final posts = await _postRepository.fetchPosts(page: 1);
      state = state.copyWith(
        posts: posts,
        isLoadingInitial: false,
        currentPage: 1,
        hasMore: true,
      );
    } catch (e) {
      state = state.copyWith(isLoadingInitial: false);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoadingInitial) return;

    state = state.copyWith(isLoadingMore: true);
    
    try {
      final nextPage = state.currentPage + 1;
      final newPosts = await _postRepository.fetchPosts(page: nextPage);
      
      state = state.copyWith(
        posts: [...state.posts, ...newPosts],
        currentPage: nextPage,
        isLoadingMore: false,
        hasMore: nextPage < 5, // Stop fetching after page 5
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

final feedNotifierProvider = StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return FeedNotifier(repository);
});
