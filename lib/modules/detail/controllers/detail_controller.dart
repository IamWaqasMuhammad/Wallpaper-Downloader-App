import 'package:get/get.dart';
import 'package:wallpaper_downloader/data/models/wallpaper_model.dart';
import 'package:wallpaper_downloader/data/providers/download_service.dart';

/// Detail controller for download management
class DetailController extends GetxController {
  final DownloadService _downloadService;

  DetailController({DownloadService? downloadService})
    : _downloadService = downloadService ?? DownloadService();

  // Observable state
  final isDownloading = false.obs;
  final downloadProgress = 0.0.obs;
  final downloadSuccess = false.obs;

  late WallpaperModel wallpaper;

  @override
  void onInit() {
    super.onInit();
    wallpaper = Get.arguments as WallpaperModel;
  }

  /// Download wallpaper with progress tracking
  Future<void> downloadWallpaper() async {
    try {
      isDownloading.value = true;
      downloadProgress.value = 0.0;
      downloadSuccess.value = false;

      final success = await _downloadService.downloadImage(
        imageUrl: wallpaper.src,
        imageId: wallpaper.id,
        onProgress: (progress) {
          downloadProgress.value = progress;
        },
      );

      if (success) {
        downloadSuccess.value = true;
        downloadProgress.value = 1.0;

        Get.snackbar(
          'Success',
          'Wallpaper saved to gallery',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Reset after delay
        await Future.delayed(const Duration(seconds: 2));
        downloadSuccess.value = false;
        downloadProgress.value = 0.0;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().contains('permission')
            ? 'Please grant storage permission'
            : 'Failed to download wallpaper',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isDownloading.value = false;
    }
  }
}
