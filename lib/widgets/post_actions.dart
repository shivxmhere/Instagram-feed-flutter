import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/providers/post_interaction_provider.dart';
import 'package:instagram_feed/utils/snackbar_helper.dart';

class PostActions extends ConsumerStatefulWidget {
  final String postId;

  const PostActions({super.key, required this.postId});

  @override
  ConsumerState<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends ConsumerState<PostActions>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimController;
  late Animation<double> _likeAnimation;

  @override
  void initState() {
    super.initState();
    _likeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.4).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40, // 80ms / 200ms
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.4, end: 0.9).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30, // 60ms / 200ms
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.9, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30, // 60ms / 200ms
      ),
    ]).animate(_likeAnimController);
  }

  @override
  void dispose() {
    _likeAnimController.dispose();
    super.dispose();
  }

  void _onLike() {
    ref.read(postInteractionProvider.notifier).toggleLike(widget.postId);
    _likeAnimController.forward(from: 0.0);
  }

  void _onSave() {
    ref.read(postInteractionProvider.notifier).toggleSave(widget.postId);
  }

  void _showSnackbar(BuildContext context, String message) {
    showInstagramSnackbar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final interactions = ref.watch(postInteractionProvider);
    final interaction = interactions[widget.postId];
    final isLiked = interaction?.isLiked ?? false;
    final isSaved = interaction?.isSaved ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            onTap: _onLike,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: ScaleTransition(
                  scale: _likeAnimation,
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Comment button
          GestureDetector(
            onTap: () => _showSnackbar(context, 'Comments coming soon!'),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(Icons.chat_bubble_outline, size: 24, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Share button
          GestureDetector(
            onTap: () => _showSnackbar(context, 'Share feature coming soon!'),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Transform.rotate(
                  angle: -0.4,
                  child: const Icon(Icons.send_outlined, size: 24, color: Colors.black),
                ),
              ),
            ),
          ),
          const Spacer(),
          // Save button
          GestureDetector(
            onTap: _onSave,
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.black,
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
