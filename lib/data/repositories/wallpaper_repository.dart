import '../models/api_response.dart';
import '../models/wallpaper_model.dart';
import '../providers/api_service.dart';

/// Repository for wallpaper data management
/// Abstracts data sources and provides clean API to controllers
class WallpaperRepository {
  final ApiService _apiService;

  WallpaperRepository({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Fetch wallpapers with pagination
  Future<ApiResponse<List<WallpaperModel>>> getWallpapers({
    required String query,
    required int page,
  }) async {
    return await _apiService.fetchWallpapers(
      query: query,
      page: page,
    );
  }

  /// Future: Add caching layer here if needed
  /// Future: Add local database for offline support
}
