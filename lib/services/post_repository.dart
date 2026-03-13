import 'package:instagram_feed/models/post_model.dart';
import 'package:instagram_feed/models/story_model.dart';
import 'dart:math';

class PostRepository {
  final List<String> _unsplashImages = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800&q=80',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=800&q=80',
    'https://images.unsplash.com/photo-1501854140801-50d01698950b?w=800&q=80',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800&q=80',
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=800&q=80',
    'https://images.unsplash.com/photo-1447752875215-b2761acb3c5d?w=800&q=80',
    'https://images.unsplash.com/photo-1418065460487-3e41a6c84dc5?w=800&q=80',
    'https://images.unsplash.com/photo-1504701954957-2010ec3bcec1?w=800&q=80',
    'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=800&q=80',
    'https://images.unsplash.com/photo-1518173946687-a4c8892bbd9f?w=800&q=80',
  ];

  final List<String> _usernames = [
    'shivxmhere', 'alex_travels', 'nature_vibes', 'city_explorer', 'foodie_john',
    'creative_mind', 'photo_lover', 'dev_journey', 'coding_life', 'fitness_guru'
  ];

  final List<String> _locations = [
    'San Francisco', 'New York City', 'Paris, France', 'Tokyo, Japan', 'London, UK',
    'Sydney', 'Dubai', 'Rome, Italy', 'Bali, Indonesia', 'Los Angeles'
  ];

  final List<String> _captions = [
    'Loving this view entirely! So peaceful 😌',
    'What a day to remember! Can\'t wait to go back.',
    'Just another magical moment captured 📸',
    'Nature never fails to amaze me.',
    'Exploring new horizons and writing new chapters.',
    'Weekend vibes only! ✨',
    'A quick getaway from the city hustle.',
    'Coffee, code, and stunning views.',
    'Creating memories one day at a time.',
    'Simplicity is the ultimate sophistication.'
  ];

  final List<String> _timeAgos = ['2m', '15m', '1h', '2h', '5h', '10h', '1d', '2d', '3d', '1w'];

  List<PostModel> _generatePosts(int page) {
    final List<PostModel> posts = [];
    final random = Random(page); // seed with page for consistent randomness per page if needed, or just Random()
    
    for (int i = 0; i < 10; i++) {
      final postIndex = (page * 10) + i;
      
      // Determine carousel
      final bool isCarousel = i < 3; // 3 out of 10
      List<String> imageUrls = [];
      
      if (isCarousel) {
        int imgCount = 2 + random.nextInt(2); // 2 or 3
        for (int j = 0; j < imgCount; j++) {
          imageUrls.add(_unsplashImages[(postIndex + j) % _unsplashImages.length]);
        }
      } else {
        imageUrls.add(_unsplashImages[postIndex % _unsplashImages.length]);
      }

      posts.add(PostModel(
        id: 'post_$postIndex',
        username: _usernames[postIndex % _usernames.length],
        userAvatarUrl: 'https://i.pravatar.cc/150?img=${(postIndex % 20) + 1}',
        isVerified: random.nextBool(),
        location: random.nextBool() ? _locations[postIndex % _locations.length] : null,
        imageUrls: imageUrls,
        caption: _captions[postIndex % _captions.length],
        likeCount: 50 + random.nextInt(950),
        commentCount: 5 + random.nextInt(95),
        timeAgo: _timeAgos[postIndex % _timeAgos.length],
      ));
    }
    
    // Shuffle slightly to distribute carousels
    posts.shuffle(Random(page));
    return posts;
  }

  Future<List<PostModel>> fetchPosts({required int page}) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _generatePosts(page);
  }

  Future<List<StoryModel>> fetchStories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final List<StoryModel> stories = [];
    
    // First item is own story
    stories.add(StoryModel(
      id: 'story_own',
      username: 'Your Story',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      isOwn: true,
      isSeen: false,
    ));

    for (int i = 1; i < 10; i++) {
      stories.add(StoryModel(
        id: 'story_$i',
        username: _usernames[i % _usernames.length],
        avatarUrl: 'https://i.pravatar.cc/150?img=${i + 1}',
        isSeen: i > 5, // Just some variation
      ));
    }
    
    return stories;
  }
}
