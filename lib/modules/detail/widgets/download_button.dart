import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wallpaper_downloader/core/theme/app_colors.dart';
import 'package:wallpaper_downloader/core/theme/app_text_styles.dart';
import 'package:wallpaper_downloader/core/utils/responsive_util.dart';

/// Enhanced animated download button with progress and responsive design
class DownloadButton extends StatelessWidget {
  final bool isDownloading;
  final bool downloadSuccess;
  final double progress;
  final VoidCallback onPressed;

  const DownloadButton({
    super.key,
    required this.isDownloading,
    required this.downloadSuccess,
    required this.progress,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isDownloading ? 60.w : 200.w,
          height: 60.h,
          child: isDownloading
              ? _buildProgressIndicator()
              : _buildDownloadButton(),
        )
        .animate(target: downloadSuccess ? 1 : 0)
        .scale(duration: 300.ms, curve: Curves.easeInOut);
  }

  Widget _buildProgressIndicator() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 3.w,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              backgroundColor: AppColors.border,
            ),
          ),
          Text(
            '${(progress * 100).toInt()}%',
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    return ElevatedButton(
          onPressed: downloadSuccess ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: downloadSuccess
                ? AppColors.success
                : AppColors.primary,
            foregroundColor: AppColors.textPrimary,
            elevation: 8,
            shadowColor: downloadSuccess
                ? AppColors.success.withValues(alpha: 0.5)
                : AppColors.primary.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ResponsiveUtil.radius(30)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                downloadSuccess
                    ? Icons.check_circle_rounded
                    : Icons.download_rounded,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              Text(
                downloadSuccess ? 'Downloaded' : 'Download',
                style: AppTextStyles.button,
              ),
            ],
          ),
        )
        .animate()
        .shimmer(duration: 2000.ms, delay: 500.ms)
        .then()
        .shake(hz: 2, duration: 500.ms);
  }
}
