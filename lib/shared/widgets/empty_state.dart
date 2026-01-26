import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper_downloader/core/theme/app_colors.dart';
import 'package:wallpaper_downloader/core/theme/app_text_styles.dart';

/// Enhanced empty state widget with Lottie animation
class EmptyState extends StatelessWidget {
  final String title;
  final String message;

  const EmptyState({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Empty State Animation
            SizedBox(
              width: 200.w,
              height: 200.w,
              child: Lottie.network(
                'https://assets9.lottiefiles.com/packages/lf20_47pyyfcf.json', // Search empty
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.search_off_rounded,
                    size: 80.w,
                    color: Theme.of(context).hintColor,
                  );
                },
              ),
            ),

            SizedBox(height: 24.h),

            Text(
              title,
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
          ],
        ),
      ),
    );
  }
}
