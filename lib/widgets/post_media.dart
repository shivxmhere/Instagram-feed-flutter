import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instagram_feed/models/post_model.dart';
import 'package:instagram_feed/widgets/pinch_zoom_widget.dart';
import 'package:instagram_feed/widgets/carousel_widget.dart';

class PostMedia extends StatelessWidget {
  final PostModel post;

  const PostMedia({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    if (post.imageUrls.length == 1) {
      return PinchZoomWidget(
        child: CachedNetworkImage(
          imageUrl: post.imageUrls.first,
          height: 375,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0),
            highlightColor: const Color(0xFFF5F5F5),
            child: Container(
              height: 375,
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: 375,
            width: double.infinity,
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.broken_image,
              size: 40,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return CarouselWidget(imageUrls: post.imageUrls);
  }
}
