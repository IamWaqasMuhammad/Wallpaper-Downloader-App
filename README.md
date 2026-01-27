# 🖼️ Wallpaper Downloader App

[![Flutter](https://img.shields.io/badge/Flutter-v3.10+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![GetX](https://img.shields.io/badge/GetX-v4.6+-651FFF?style=for-the-badge&logo=get.x&logoColor=white)](https://pub.dev/packages/get)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

A premium, high-performance Flutter application designed to discover and download stunning wallpapers from the [Pexels](https://www.pexels.com/api/) ecosystem. This app features a modern, responsive UI with glassmorphism touches, smooth animations, and a seamless user experience.

---

## ✨ Key Features

- 🚀 **Discover**: Explore a vast collection of curated wallpapers.
- 🔍 **Search**: Find exactly what you're looking for with real-time search.
- 📂 **Categories**: Browse popular themes like Nature, Architecture, Abstract, and more.
- 💾 **One-Tap Download**: High-quality downloads directly to your gallery.
- 🌓 **Dynamic Themes**: Beautiful Dark and Light modes for any environment.
- 📱 **Responsive Design**: Optimized for various screen sizes using `flutter_screenutil`.
- ⚡ **Performance**: Efficient image caching and shimmer effects for a premium feel.

---

## 🛠️ Tech Stack & Architecture

This project follows the **GetX Pattern**, ensuring a clean separation of concerns and reactive state management.

- **State Management**: [GetX](https://pub.dev/packages/get)
- **Dependency Injection**: Integrated GetX injection
- **Routing**: GetX Named Routing
- **Network**: [http](https://pub.dev/packages/http) with Pexels API
- **UI & Animations**:
  - `google_fonts` for premium typography
  - `flutter_animate` & `lottie` for micro-interactions
  - `shimmer` for elegant loading states
  - `cached_network_image` for optimized data usage
- **Utilities**: `responsive_util` for multi-device support

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.10 or higher)
- Dart SDK
- [Pexels API Key](https://www.pexels.com/api/new/)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/IamWaqasMuhammad/Wallpaper-Downloader-App.git
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API Key**:
   Open `lib/core/constants/app_constants.dart` and add your API key:
   ```dart
   static const String apiKey = 'YOUR_PEXELS_API_KEY';
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
lib/
├── core/             # Global configurations, theme, and constants
├── data/             # Models and API providers
├── modules/          # Feature-based pages (Home, Detail)
│   ├── home/         # UI, Controllers, and Widgets for Home
│   └── detail/       # UI, Controllers, and Widgets for Detail
├── routes/           # Navigation and page management
├── shared/           # Reusable widgets and common utilities
└── app_barrels.dart  # Centralized export management
```

---

## 📸 Preview

| Home Screen | Detail View | Dark Mode |
| :---: | :---: | :---: |
| ![Home](https://via.placeholder.com/200x400?text=Home+Screen) | ![Detail](https://via.placeholder.com/200x400?text=Detail+View) | ![Dark](https://via.placeholder.com/200x400?text=Dark+Mode) |

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<p align="center">Made with ❤️ by Waqas Muhammad</p>
