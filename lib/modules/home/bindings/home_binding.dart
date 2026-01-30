import 'package:get/get.dart';
import 'package:wallpaper_downloader/data/providers/download_service.dart';
import 'package:wallpaper_downloader/data/repositories/wallpaper_repository.dart';
import 'package:wallpaper_downloader/modules/home/controllers/home_controller.dart';

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
