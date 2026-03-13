import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_feed/models/story_model.dart';

class StoryAvatar extends StatelessWidget {
  final StoryModel story;

  const StoryAvatar({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              _buildAvatarCircle(),
              if (story.isOwn) _buildAddButton(),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            story.isOwn ? 'Your Story' : story.username,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle() {
    if (story.isOwn) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: story.avatarUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey.shade200),
            errorWidget: (context, url, error) => const Icon(Icons.person),
          ),
        ),
      );
    }

    // Gradient ring for unseen
    if (!story.isSeen) {
      return Container(
        width: 64,
        height: 64,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFFF09433),
              Color(0xFFE6683C),
              Color(0xFFDC2743),
              Color(0xFFCC2366),
              Color(0xFFBC1888),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.5), // Ring width
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(2), // Gap between ring and image
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: story.avatarUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey.shade200),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
        ),
      );
    }

    // Grey ring for seen
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: story.avatarUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey.shade200),
          errorWidget: (context, url, error) => const Icon(Icons.person),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: const Color(0xFF3897F0),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 14, color: Colors.white),
        ),
      ),
    );
  }
}
