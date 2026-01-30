import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper_downloader/core/theme/app_colors.dart';
import 'package:wallpaper_downloader/core/theme/app_text_styles.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Error Animation
            SizedBox(
              width: 150.w,
              height: 150.w,
              child: Lottie.network(
                'https://assets10.lottiefiles.com/packages/lf20_afwjhubm.json', // Error robot
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error_outline_rounded,
                    size: 80.w,
                    color: Theme.of(context).colorScheme.error,
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              'Oops!',
              style: AppTextStyles.headlineLarge,
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.3, end: 0),

            SizedBox(height: 12.h),

            Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideY(begin: 0.3, end: 0),

            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.w,
                        vertical: 16.h,
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 300.ms, delay: 200.ms)
                  .slideY(begin: 0.3, end: 0)
                  .shimmer(duration: 2000.ms, delay: 1000.ms),
            ],
          ],
        ),
      ),
    );
  }
}
