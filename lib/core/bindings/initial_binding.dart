import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/providers/api_service.dart';
import '../../data/providers/download_service.dart';
import '../../data/repositories/wallpaper_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<http.Client>(http.Client(), permanent: true);
    Get.put<ApiService>(ApiService(client: Get.find<http.Client>()), permanent: true);
    Get.put<DownloadService>(DownloadService(), permanent: true);
    Get.put<WallpaperRepository>(
      WallpaperRepository(apiService: Get.find<ApiService>()),
      permanent: true,
    );
  }
}
