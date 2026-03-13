# Instagram Feed Clone — Flutter

A pixel-perfect replication of the Instagram Home Feed built as part of a Flutter internship assignment.

## State Management
**Riverpod (flutter_riverpod)** was chosen because:
- It provides compile-safe providers with no BuildContext dependency
- StateNotifier makes feed pagination state predictable and testable
- Separation between FeedNotifier (list/pagination) and PostInteractionNotifier (like/save per post) keeps concerns clean

## Features
- Pixel-perfect Instagram UI (top bar, stories, post feed)
- Shimmer skeleton loading (1.5s simulated latency)
- Infinite scroll pagination (10 posts/page, up to 5 pages)
- Image carousel with SmoothPageIndicator
- Pinch-to-Zoom with smooth spring-back animation
- Like ❤️ and Save 🔖 toggle with animation
- Network image caching via cached_network_image
- Error states for failed image loads
- Snackbar for unimplemented actions

## How to Run
1. Make sure Flutter SDK is installed (>= 3.0.0)
2. Clone this repo:
   ```bash
   git clone https://github.com/shivxmhere/-Instagram-Pixel-Perfect-Feed.git
   ```
3. Navigate to project:
   ```bash
   cd -Instagram-Pixel-Perfect-Feed
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## Demo
[Add your Loom or MP4 link here after recording]

## Packages Used
| Package | Purpose |
|---|---|
| flutter_riverpod | State management |
| cached_network_image | Network image caching |
| shimmer | Skeleton loading UI |
| smooth_page_indicator | Carousel dot indicator |

## Project Structure
```
lib/
├── main.dart
├── models/
│   ├── post_model.dart
│   └── story_model.dart
├── services/
│   └── post_repository.dart
├── providers/
│   ├── feed_provider.dart
│   └── post_interaction_provider.dart
├── widgets/
│   ├── top_bar.dart
│   ├── story_tray.dart
│   ├── story_avatar.dart
│   ├── post_card.dart
│   ├── post_header.dart
│   ├── post_media.dart
│   ├── carousel_widget.dart
│   ├── pinch_zoom_widget.dart
│   ├── post_actions.dart
│   ├── post_footer.dart
│   └── shimmer_feed.dart
└── screens/
    └── home_screen.dart
```

## License
MIT
