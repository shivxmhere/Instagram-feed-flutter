import 'package:flutter/material.dart';
import 'package:instagram_feed/models/story_model.dart';
import 'package:instagram_feed/widgets/story_avatar.dart';

class StoryTray extends StatelessWidget {
  final List<StoryModel> stories;

  const StoryTray({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: StoryAvatar(story: stories[index]),
          );
        },
      ),
    );
  }
}
