<!-- Built as Flutter internship assignment -->

# Instagram Feed Clone — Flutter

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Riverpod](https://img.shields.io/badge/State-Riverpod-5C6BC0?logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Hosted-Firebase-FFCA28?logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/license-MIT-brightgreen)

> A pixel-perfect replication of the Instagram Home Feed built
> as a Flutter internship assignment. Obsessive attention to
> spacing, animations, and interaction feel.

## 🔗 Live Demo
### **[▶ Open Live App](https://instagram-feed-flutter-shivxm.web.app)**

---

## ✨ Features

| Feature | Details |
|---|---|
| Shimmer Loading | 1.5s simulated latency with full skeleton UI |
| Infinite Scroll | Lazy loads 10 posts per page, up to 50 total |
| Image Carousel | Swipeable multi-image posts with dots + slide router counter |
| Pinch-to-Zoom | Matrix4 transform with smooth spring-back animation |
| Double-Tap Like | Heart flash overlay at exact tap position |
| Like Bounce | TweenSequence 3-step bounce on heart icon |
| Story Rings | CustomPainter SweepGradient matching Instagram exactly |
| Expandable Captions | Tap "more" to expand long captions inline |
| Image Caching | Disk + memory LRU cache via cached_network_image |
| Error States | Broken image fallback with icon and message |
| Instagram Snackbar | Dark floating toast for unimplemented actions |

---

## 🏗 Architecture
lib/
├── models/          → PostModel, StoryModel
├── services/        → PostRepository (mock data + 1.5s delay)
├── providers/       → FeedNotifier, PostInteractionNotifier
├── widgets/         → All UI components (one widget per file)
├── screens/         → HomeScreen
└── utils/           → snackbar_helper.dart

---

## 🧠 State Management: Riverpod

**Why Riverpod over Provider or Bloc?**

| Decision | Reason |
|---|---|
| Riverpod over Provider | Compile-safe, no BuildContext dependency |
| Riverpod over Bloc | Less boilerplate for this scale of app |
| cached_network_image | LRU cache prevents OOM on long scroll sessions |
| Shimmer over Spinner | Reduces perceived load time, matches Instagram UX |
| CustomPainter story ring | Pixel-accurate gradient impossible with BoxDecoration |
| BouncingScrollPhysics | Matches iOS native feel expected by Instagram users |
| CanvasKit web renderer | Fonts and gradients render identically on web |

---

## 🚀 How to Run Locally
```bash
git clone https://github.com/shivxmhere/Instagram-feed-flutter.git
cd Instagram-feed-flutter
flutter pub get
flutter run -d chrome
```

Requires Flutter SDK >= 3.0.0

---

## ⚠️ Known Limitations & Next Steps

> Acknowledging tradeoffs is part of good engineering.

- No real authentication — uses mock data from PostRepository
- Comments open a Snackbar — full bottom sheet not yet implemented
- No video post support (Reels)
- No haptic feedback on like (would use HapticFeedback.lightImpact)
- Pinch-to-zoom feels more natural on touch screen than mouse

---

## 📦 Packages Used

| Package | Purpose |
|---|---|
| flutter_riverpod | State management |
| cached_network_image | Network image caching |
| shimmer | Skeleton loading UI |
| smooth_page_indicator | Carousel dot indicator |
| google_fonts | Pacifico wordmark font |

---

*Built with attention to detail for a Flutter internship assignment.*
