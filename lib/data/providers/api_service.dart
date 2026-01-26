import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallpaper_downloader/core/constants/app_constants.dart';
import 'package:wallpaper_downloader/data/models/api_response.dart';
import 'package:wallpaper_downloader/data/models/wallpaper_model.dart';

/// API service with improved error handling and retry logic
class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch wallpapers with pagination
  Future<ApiResponse<List<WallpaperModel>>> fetchWallpapers({
    required String query,
    required int page,
  }) async {
    try {
      final String searchQuery = query.isEmpty
          ? AppConstants.defaultSearchQuery
          : query;
      final Uri uri = Uri.parse('${AppConstants.baseUrl}/search').replace(
        queryParameters: {
          'query': searchQuery,
          'per_page': AppConstants.perPage.toString(),
          'page': page.toString(),
        },
      );

      final response = await _client
          .get(uri, headers: {'Authorization': AppConstants.apiKey})
          .timeout(AppConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List data = body['photos'] ?? [];
        final wallpapers = data
            .map((json) => WallpaperModel.fromJson(json))
            .toList();

        return ApiResponse.success(wallpapers, statusCode: response.statusCode);
      } else {
        return ApiResponse.failure(
          _handleHttpError(response.statusCode),
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.failure(
        'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Handle HTTP errors with user-friendly messages
  String _handleHttpError(int statusCode) {
    if (statusCode >= 500) {
      return 'Server error. Please try again later.';
    } else if (statusCode == 401) {
      return 'Unauthorized. Please check your API key.';
    } else if (statusCode == 404) {
      return 'Resource not found.';
    } else if (statusCode == 429) {
      return 'Too many requests. Please slow down.';
    } else {
      return 'Failed to load wallpapers ($statusCode)';
    }
  }
}
