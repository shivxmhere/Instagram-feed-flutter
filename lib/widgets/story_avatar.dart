import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagram_feed/models/story_model.dart';
import 'dart:math' as math;

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
            clipBehavior: Clip.none,
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
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: _buildImage(),
        ),
      );
    }

    return CustomPaint(
      painter: StoryRingPainter(isSeen: story.isSeen),
      child: SizedBox(
        width: 70, // Slightly larger than 64 to fit the 35px radius + stroke
        height: 70,
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              width: 60,
              height: 60,
              child: _buildImage(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: story.avatarUrl,
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
            Icon(Icons.image_not_supported_outlined, color: Colors.grey, size: 40),
            SizedBox(height: 8),
            Text("Image unavailable", style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: const Color(0xFF3897F0),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.add, size: 12, color: Colors.white),
        ),
      ),
    );
  }
}

class StoryRingPainter extends CustomPainter {
  final bool isSeen;

  StoryRingPainter({required this.isSeen});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    
    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    if (!isSeen) {
      const Gradient gradient = SweepGradient(
        colors: [
          Color(0xFFf09433),
          Color(0xFFe6683c),
          Color(0xFFdc2743),
          Color(0xFFcc2366),
          Color(0xFFbc1888),
          Color(0xFF833ab4),
        ],
        stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
      );
      
      canvas.save();
      // Rotate by -PI/2 so gradient starts at top
      canvas.translate(center.dx, center.dy);
      canvas.rotate(-math.pi / 2);
      canvas.translate(-center.dx, -center.dy);
      
      ringPaint.shader = gradient.createShader(Rect.fromCircle(center: center, radius: 35));
    } else {
      ringPaint.color = const Color(0xFFDBDBDB);
    }

    // Draw the outer ring
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 35),
      0,
      2 * math.pi,
      false,
      ringPaint,
    );

    if (!isSeen) {
      canvas.restore();
    }

    // Draw the white gap
    final Paint gapPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Draw white filled circle (the gap layer under the image but over anything else)
    // Wait, since we are returning a CustomPaint wrapping a child, 
    // the white circle would draw behind the child. That's fine.
    canvas.drawCircle(center, 32.5, gapPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
