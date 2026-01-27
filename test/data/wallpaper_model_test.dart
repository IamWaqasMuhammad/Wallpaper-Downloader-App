import 'package:flutter_test/flutter_test.dart';
import 'package:wallpaper_downloader/data/models/wallpaper_model.dart';

void main() {
  group('WallpaperModel Tests', () {
    final testJson = {
      'id': 123,
      'url': 'https://pexels.com/photo/123',
      'photographer': 'John Doe',
      'photographer_url': 'https://pexels.com/@johndoe',
      'src': {
        'large2x': 'https://images.pexels.com/123/large2x.jpg',
        'medium': 'https://images.pexels.com/123/medium.jpg',
      },
      'width': 1000,
      'height': 2000,
      'avg_color': '#FFFFFF',
    };

    test('fromJson should parse correctly', () {
      final model = WallpaperModel.fromJson(testJson);

      expect(model.id, 123);
      expect(model.photographer, 'John Doe');
      expect(model.src, 'https://images.pexels.com/123/large2x.jpg');
      expect(model.width, 1000);
      expect(model.height, 2000);
      expect(model.avgColor, '#FFFFFF');
    });

    test('toJson should convert correctly', () {
      final model = WallpaperModel.fromJson(testJson);
      final json = model.toJson();

      expect(json['id'], 123);
      expect(json['src']['large2x'], 'https://images.pexels.com/123/large2x.jpg');
    });

    test('aspectRatio should return correct orientation', () {
      final portrait = WallpaperModel.fromJson(testJson);
      expect(portrait.aspectRatio, 'Portrait');

      final landscape = portrait.copyWith(width: 2000, height: 1000);
      expect(landscape.aspectRatio, 'Landscape');

      final square = portrait.copyWith(width: 1000, height: 1000);
      expect(square.aspectRatio, 'Square');
    });

    test('resolution should return formatted string', () {
      final model = WallpaperModel.fromJson(testJson);
      expect(model.resolution, '1000x2000');
    });
  });
}
