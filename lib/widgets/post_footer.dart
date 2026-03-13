import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/models/post_model.dart';
import 'package:instagram_feed/providers/post_interaction_provider.dart';
import 'package:instagram_feed/utils/snackbar_helper.dart';

class PostFooter extends ConsumerStatefulWidget {
  final PostModel post;

  const PostFooter({super.key, required this.post});

  @override
  ConsumerState<PostFooter> createState() => _PostFooterState();
}

class _PostFooterState extends ConsumerState<PostFooter> {
  bool _isExpanded = false;

  void _showSnackbar(BuildContext context, String message) {
    showInstagramSnackbar(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final interactions = ref.watch(postInteractionProvider);
    final interaction = interactions[widget.post.id];
    final likeCount = interaction?.likeCount ?? widget.post.likeCount;

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
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: RichText(
              maxLines: _isExpanded ? null : 2,
              overflow: _isExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 13.5),
                children: [
                  TextSpan(
                    text: widget.post.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: ' ${widget.post.caption}'),
                  if (!_isExpanded && widget.post.caption.length > 100)
                    const TextSpan(
                      text: ' more',
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Comment count
          if (widget.post.commentCount > 0) ...[
            GestureDetector(
              onTap: () => _showSnackbar(context, 'Comments coming soon!'),
              child: Text(
                'View all ${widget.post.commentCount} comments',
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
            widget.post.timeAgo,
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
