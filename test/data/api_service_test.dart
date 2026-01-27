import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:wallpaper_downloader/data/providers/api_service.dart';

void main() {
  group('ApiService Tests', () {
    test('fetchWallpapers returns list of wallpapers on success', () async {
      final mockClient = MockClient((request) async {
        final response = {
          'photos': [
            {
              'id': 1,
              'photographer': 'Test',
              'src': {'large2x': 'url', 'medium': 'url'}
            }
          ]
        };
        return http.Response(json.encode(response), 200);
      });

      final apiService = ApiService(client: mockClient);
      final response = await apiService.fetchWallpapers(query: 'nature', page: 1);

      expect(response.isSuccess, true);
      expect(response.data!.length, 1);
      expect(response.data![0].photographer, 'Test');
    });

    test('fetchWallpapers returns failure on error status code', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final apiService = ApiService(client: mockClient);
      final response = await apiService.fetchWallpapers(query: 'nature', page: 1);

      expect(response.isSuccess, false);
      expect(response.error, contains('Resource not found'));
    });

    test('fetchWallpapers returns failure on exception', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Network error');
      });

      final apiService = ApiService(client: mockClient);
      final response = await apiService.fetchWallpapers(query: 'nature', page: 1);

      expect(response.isSuccess, false);
      expect(response.error, contains('An unexpected error occurred'));
    });
  });
}
