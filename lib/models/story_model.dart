class StoryModel {
  final String id;
  final String username;
  final String avatarUrl;
  final bool isOwn;
  final bool isSeen;

  StoryModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    this.isOwn = false,
    this.isSeen = false,
  });
}
