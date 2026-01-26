import 'package:get/get.dart';
import '../../../data/providers/download_service.dart';
import '../controllers/detail_controller.dart';

/// Detail binding for dependency injection
class DetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailController>(
      () => DetailController(downloadService: Get.find<DownloadService>()),
    );
  }
}
