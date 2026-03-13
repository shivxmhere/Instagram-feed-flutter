import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/models/post_model.dart';

class PostInteraction {
  final bool isLiked;
  final bool isSaved;
  final int likeCount;

  PostInteraction({
    required this.isLiked,
    required this.isSaved,
    required this.likeCount,
  });

  PostInteraction copyWith({
    bool? isLiked,
    bool? isSaved,
    int? likeCount,
  }) {
    return PostInteraction(
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      likeCount: likeCount ?? this.likeCount,
    );
  }
}

class PostInteractionNotifier extends StateNotifier<Map<String, PostInteraction>> {
  PostInteractionNotifier() : super({});

  void initialize(List<PostModel> posts) {
    final newState = {...state};
    for (var post in posts) {
      if (!newState.containsKey(post.id)) {
        newState[post.id] = PostInteraction(
          isLiked: post.isLiked,
          isSaved: post.isSaved,
          likeCount: post.likeCount,
        );
      }
    }
    state = newState;
  }

  void toggleLike(String postId) {
    if (!state.containsKey(postId)) return;

    final current = state[postId]!;
    final newIsLiked = !current.isLiked;
    final newCount = newIsLiked ? current.likeCount + 1 : current.likeCount - 1;

    state = {
      ...state,
      postId: current.copyWith(
        isLiked: newIsLiked,
        likeCount: newCount,
      ),
    };
  }

  void toggleSave(String postId) {
    if (!state.containsKey(postId)) return;

    final current = state[postId]!;
    
    state = {
      ...state,
      postId: current.copyWith(
        isSaved: !current.isSaved,
      ),
    };
  }
}

final postInteractionProvider = StateNotifierProvider<PostInteractionNotifier, Map<String, PostInteraction>>((ref) {
  return PostInteractionNotifier();
});
