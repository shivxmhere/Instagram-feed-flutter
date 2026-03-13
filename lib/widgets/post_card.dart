import 'package:flutter/material.dart';
import 'package:instagram_feed/models/post_model.dart';
import 'package:instagram_feed/widgets/post_header.dart';
import 'package:instagram_feed/widgets/post_media.dart';
import 'package:instagram_feed/widgets/post_actions.dart';
import 'package:instagram_feed/widgets/post_footer.dart';

class PostCard extends StatelessWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(post: post),
          PostMedia(post: post),
          PostActions(postId: post.id),
          PostFooter(post: post),
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}
