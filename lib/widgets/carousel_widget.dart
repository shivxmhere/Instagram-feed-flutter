import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:instagram_feed/widgets/pinch_zoom_widget.dart';

class CarouselWidget extends StatefulWidget {
  final List<String> imageUrls;

  const CarouselWidget({super.key, required this.imageUrls});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 375,
          child: PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return PinchZoomWidget(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrls[index],
                  width: double.infinity,
                  height: 375,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: const Color(0xFFE0E0E0),
                    highlightColor: const Color(0xFFF5F5F5),
                    child: Container(
                      width: double.infinity,
                      height: 375,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 375,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SmoothPageIndicator(
            controller: _pageController,
            count: widget.imageUrls.length,
            effect: WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: const Color(0xFF3897F0),
              dotColor: Colors.grey.shade300,
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
