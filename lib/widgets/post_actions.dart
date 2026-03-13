import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/providers/post_interaction_provider.dart';

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
      duration: const Duration(milliseconds: 150),
    );
    _likeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _likeAnimController, curve: Curves.easeInOut),
    );
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
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black87,
    ));
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
