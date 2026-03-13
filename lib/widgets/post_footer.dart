import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/models/post_model.dart';
import 'package:instagram_feed/providers/post_interaction_provider.dart';

class PostFooter extends ConsumerWidget {
  final PostModel post;

  const PostFooter({super.key, required this.post});

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
  Widget build(BuildContext context, WidgetRef ref) {
    final interactions = ref.watch(postInteractionProvider);
    final interaction = interactions[post.id];
    final likeCount = interaction?.likeCount ?? post.likeCount;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Like count
          Text(
            '$likeCount likes',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          // Caption
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: const TextStyle(fontSize: 13.5, color: Colors.black),
              children: [
                TextSpan(
                  text: post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' ${post.caption}'),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Comment count
          if (post.commentCount > 0) ...[
            GestureDetector(
              onTap: () => _showSnackbar(context, 'Comments coming soon!'),
              child: Text(
                'View all ${post.commentCount} comments',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13.5,
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
          // Time ago
          Text(
            post.timeAgo,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
