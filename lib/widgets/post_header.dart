import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_feed/models/post_model.dart';

class PostHeader extends StatelessWidget {
  final PostModel post;

  const PostHeader({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: post.userAvatarUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(color: Colors.grey.shade200),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Username + location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        post.username,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (post.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF3897F0),
                        size: 13,
                      ),
                    ],
                  ],
                ),
                if (post.location != null)
                  Text(
                    post.location!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // Follow + more button
          Text(
            'Follow',
            style: const TextStyle(
              color: Color(0xFF3897F0),
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.more_horiz, size: 20, color: Colors.black),
        ],
      ),
    );
  }
}
