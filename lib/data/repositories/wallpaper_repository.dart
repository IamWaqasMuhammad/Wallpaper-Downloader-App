import 'package:wallpaper_downloader/data/models/api_response.dart';
import 'package:wallpaper_downloader/data/models/wallpaper_model.dart';
import 'package:wallpaper_downloader/data/providers/api_service.dart';


class WallpaperRepository {
  final ApiService _apiService;

  WallpaperRepository({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  /// Fetch wallpapers
  Future<ApiResponse<List<WallpaperModel>>> getWallpapers({
    required String query,
    required int page,
  }) async {
    return await _apiService.fetchWallpapers(query: query, page: page);
  }


}
