class PostModel {
  final String id;
  final String username;
  final String userAvatarUrl;
  final bool isVerified;
  final String? location;
  final List<String> imageUrls;
  final String caption;
  final int likeCount;
  final int commentCount;
  final String timeAgo;
  final bool isLiked;
  final bool isSaved;

  PostModel({
    required this.id,
    required this.username,
    required this.userAvatarUrl,
    this.isVerified = false,
    this.location,
    required this.imageUrls,
    required this.caption,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.timeAgo,
    this.isLiked = false,
    this.isSaved = false,
  });

  PostModel copyWith({
    String? id,
    String? username,
    String? userAvatarUrl,
    bool? isVerified,
    String? location,
    List<String>? imageUrls,
    String? caption,
    int? likeCount,
    int? commentCount,
    String? timeAgo,
    bool? isLiked,
    bool? isSaved,
  }) {
    return PostModel(
      id: id ?? this.id,
      username: username ?? this.username,
      userAvatarUrl: userAvatarUrl ?? this.userAvatarUrl,
      isVerified: isVerified ?? this.isVerified,
      location: location ?? this.location,
      imageUrls: imageUrls ?? this.imageUrls,
      caption: caption ?? this.caption,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      timeAgo: timeAgo ?? this.timeAgo,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
