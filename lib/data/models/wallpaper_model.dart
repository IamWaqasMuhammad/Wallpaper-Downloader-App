/// Wallpaper model with enhanced fields
class WallpaperModel {
  final int id;
  final String url;
  final String photographer;
  final String photographerUrl;
  final String src;
  final String srcMedium;
  final int width;
  final int height;
  final String? avgColor;

  WallpaperModel({
    required this.id,
    required this.url,
    required this.photographer,
    required this.photographerUrl,
    required this.src,
    required this.srcMedium,
    required this.width,
    required this.height,
    this.avgColor,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'] ?? 0,
      url: json['url'] ?? '',
      photographer: json['photographer'] ?? 'Unknown',
      photographerUrl: json['photographer_url'] ?? '',
      src: json['src']['large2x'] ?? '',
      srcMedium: json['src']['medium'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      avgColor: json['avg_color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'photographer': photographer,
      'photographer_url': photographerUrl,
      'src': {'large2x': src, 'medium': srcMedium},
      'width': width,
      'height': height,
      'avg_color': avgColor,
    };
  }

  WallpaperModel copyWith({
    int? id,
    String? url,
    String? photographer,
    String? photographerUrl,
    String? src,
    String? srcMedium,
    int? width,
    int? height,
    String? avgColor,
  }) {
    return WallpaperModel(
      id: id ?? this.id,
      url: url ?? this.url,
      photographer: photographer ?? this.photographer,
      photographerUrl: photographerUrl ?? this.photographerUrl,
      src: src ?? this.src,
      srcMedium: srcMedium ?? this.srcMedium,
      width: width ?? this.width,
      height: height ?? this.height,
      avgColor: avgColor ?? this.avgColor,
    );
  }

  String get aspectRatio {
    if (width == 0 || height == 0) return 'Unknown';
    final ratio = width / height;
    if (ratio > 1.5) return 'Landscape';
    if (ratio < 0.75) return 'Portrait';
    return 'Square';
  }

  String get resolution => '${width}x$height';
}
