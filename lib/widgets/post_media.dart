import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagram_feed/models/post_model.dart';
import 'package:instagram_feed/providers/post_interaction_provider.dart';
import 'package:instagram_feed/widgets/pinch_zoom_widget.dart';
import 'package:instagram_feed/widgets/carousel_widget.dart';

class PostMedia extends ConsumerStatefulWidget {
  final PostModel post;

  const PostMedia({super.key, required this.post});

  @override
  ConsumerState<PostMedia> createState() => _PostMediaState();
}

class _PostMediaState extends ConsumerState<PostMedia> {
  bool _isHeartVisible = false;
  Offset _heartPosition = Offset.zero;

  void _onDoubleTapDown(TapDownDetails details) {
    _heartPosition = details.localPosition;
  }

  void _onDoubleTap() {
    final interactions = ref.read(postInteractionProvider);
    final interaction = interactions[widget.post.id];
    final isLiked = interaction?.isLiked ?? false;

    if (!isLiked) {
      ref.read(postInteractionProvider.notifier).toggleLike(widget.post.id);
      _showHeart(isCenter: false);
    }
  }

  void _showHeart({required bool isCenter}) {
    if (isCenter) {
      _heartPosition = Offset.zero;
    }

    setState(() {
      _isHeartVisible = true;
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isHeartVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for like changes (e.g. from the heart button)
    ref.listen<Map<String, PostInteraction>>(postInteractionProvider, (previous, next) {
      final prevLiked = previous?[widget.post.id]?.isLiked ?? false;
      final nextLiked = next[widget.post.id]?.isLiked ?? false;

      // Show center heart only when going from unliked to liked
      if (!prevLiked && nextLiked && !_isHeartVisible) {
        _heartPosition = Offset.zero; // This will trigger center alignment in the Stack logic below
        _showHeart(isCenter: true);
      }
    });

    Widget mediaContent;
    if (widget.post.imageUrls.length == 1) {
      mediaContent = PinchZoomWidget(
        child: CachedNetworkImage(
          imageUrl: widget.post.imageUrls.first,
          height: 375,
          width: double.infinity,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 100),
          placeholder: (context, url) => Container(
            color: const Color(0xFFF0F0F0),
            height: 375,
            width: double.infinity,
          ),
          errorWidget: (context, url, error) => Container(
            height: 375,
            color: const Color(0xFFF0F0F0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_outlined,
                     color: Colors.grey, size: 40),
                SizedBox(height: 8),
                Text("Image unavailable",
                     style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ),
      );
    } else {
      mediaContent = CarouselWidget(imageUrls: widget.post.imageUrls);
    }

    return GestureDetector(
      onDoubleTapDown: _onDoubleTapDown,
      onDoubleTap: _onDoubleTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          mediaContent,
          if (_isHeartVisible)
            _heartPosition == Offset.zero
                ? IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _isHeartVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(
                        Icons.favorite,
                        size: 80,
                        color: Colors.red,
                      ),
                    ),
                  )
                : Positioned(
                    left: _heartPosition.dx - 40,
                    top: _heartPosition.dy - 40,
                    child: IgnorePointer(
                      child: AnimatedOpacity(
                        opacity: _isHeartVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.favorite,
                          size: 80,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
