import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpaper_downloader/core/theme/app_colors.dart';
import 'package:wallpaper_downloader/core/theme/app_text_styles.dart';
import 'package:wallpaper_downloader/core/utils/responsive_util.dart';
import 'package:wallpaper_downloader/modules/detail/controllers/detail_controller.dart';
import 'package:wallpaper_downloader/modules/detail/widgets/download_button.dart';
import 'package:wallpaper_downloader/shared/widgets/custom_loading.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_rounded, size: 24.w),
            onPressed: () => Get.back(),
            color: Colors.white,
          ),
        ).animate().fadeIn(duration: 400.ms).scale(),
      ),
      body: Stack(
        children: [
          // Wallpaper Image
          Hero(
            tag: 'wallpaper_${controller.wallpaper.id}',
            child: SizedBox(
              width: Get.width,
              height: Get.height,
              child: CachedNetworkImage(
                imageUrl: controller.wallpaper.src,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const CustomLoading(),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 48.w,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Info Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.9),
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Photographer Info
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Photo by',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              controller.wallpaper.photographer,
                              style: AppTextStyles.headlineSmall.copyWith(
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

                  SizedBox(height: 24.h),

                  // Image Info
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.aspect_ratio_rounded,
                        controller.wallpaper.resolution,
                      ),
                      SizedBox(width: 12.w),
                      _buildInfoChip(
                        Icons.crop_rounded,
                        controller.wallpaper.aspectRatio,
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  SizedBox(height: 32.h),

                  // Download Button
                  Center(
                        child: Obx(
                          () => DownloadButton(
                            isDownloading: controller.isDownloading.value,
                            downloadSuccess: controller.downloadSuccess.value,
                            progress: controller.downloadProgress.value,
                            onPressed: controller.downloadWallpaper,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 600.ms)
                      .scale(curve: Curves.elasticOut),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(ResponsiveUtil.radius(20)),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.w, color: AppColors.primaryLight),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
