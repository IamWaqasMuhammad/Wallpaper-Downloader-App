import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpaper_downloader/core/theme/app_colors.dart';
import 'package:wallpaper_downloader/core/theme/app_text_styles.dart';
import 'package:wallpaper_downloader/core/utils/responsive_util.dart';
import 'package:wallpaper_downloader/data/models/wallpaper_model.dart';
import 'package:wallpaper_downloader/modules/home/controllers/home_controller.dart';
import 'package:wallpaper_downloader/routes/app_routes.dart';

/// Enhanced wallpaper card with smooth animations and responsive design
class WallpaperCard extends StatelessWidget {
  final WallpaperModel wallpaper;
  final int index;

  const WallpaperCard({
    super.key,
    required this.wallpaper,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutes.detail, arguments: wallpaper);
          },
          child: Hero(
            tag: 'wallpaper_${wallpaper.id}',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveUtil.radius(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ResponsiveUtil.radius(20)),
                child: AspectRatio(
                  aspectRatio: ResponsiveUtil.cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Image with shimmer loading
                      CachedNetworkImage(
                        imageUrl: wallpaper.srcMedium,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppColors.surface,
                          highlightColor: AppColors.surfaceLight,
                          child: Container(color: AppColors.surface),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 32.w,
                          ),
                        ),
                      ),

                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Photographer info
                      Positioned(
                        bottom: 12.h,
                        left: 12.w,
                        right: 48.w, // Leave space for download button
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: AppColors.glassOverlay,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                wallpaper.photographer,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Quick Download Button
                      Positioned(
                        bottom: 8.h,
                        right: 8.w,
                        child: Obx(() {
                          final controller = Get.find<HomeController>();
                          final isDownloading = controller.downloadingIds
                              .containsKey(wallpaper.id);
                          final progress =
                              controller.downloadingIds[wallpaper.id] ?? 0.0;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () =>
                                  controller.downloadWallpaper(wallpaper),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color: isDownloading
                                      ? Colors.black54
                                      : AppColors.primary.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isDownloading
                                    ? SizedBox(
                                        width: 20.w,
                                        height: 20.w,
                                        child: CircularProgressIndicator(
                                          value: progress > 0 ? progress : null,
                                          strokeWidth: 2.w,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                Color
                                              >(Colors.white),
                                        ),
                                      )
                                    : Icon(
                                        Icons.download_rounded,
                                        size: 20.w,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 50).ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 400.ms,
          delay: (index * 50).ms,
          curve: Curves.easeOutCubic,
        );
  }
}
