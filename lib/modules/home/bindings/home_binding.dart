import 'package:get/get.dart';
import '../../../data/repositories/wallpaper_repository.dart';
import '../../../data/providers/download_service.dart';
import '../controllers/home_controller.dart';

/// Home binding for dependency injection
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        repository: Get.find<WallpaperRepository>(),
        downloadService: Get.find<DownloadService>(),
      ),
    );
  }
}
