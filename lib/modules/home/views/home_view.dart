import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wallpaper_downloader/core/services/theme_service.dart';
import 'package:wallpaper_downloader/core/theme/app_colors.dart';
import 'package:wallpaper_downloader/core/utils/responsive_util.dart';
import 'package:wallpaper_downloader/modules/home/controllers/home_controller.dart';
import 'package:wallpaper_downloader/modules/home/widgets/category_chips.dart';
import 'package:wallpaper_downloader/modules/home/widgets/search_bar_widget.dart';
import 'package:wallpaper_downloader/modules/home/widgets/wallpaper_card.dart';
import 'package:wallpaper_downloader/shared/widgets/custom_loading.dart';
import 'package:wallpaper_downloader/shared/widgets/empty_state.dart';
import 'package:wallpaper_downloader/shared/widgets/error_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          controller.clearSearch();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.onRefresh,
              color: AppColors.primary,
              backgroundColor: Theme.of(context).cardColor,
              child: CustomScrollView(
                controller: controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  // App Bar
                  SliverToBoxAdapter(child: _buildAppBar(context)),

                  // Search Bar
                  SliverToBoxAdapter(
                    child: SearchBarWidget(
                      controller: controller.searchController,
                      onChanged: controller.onSearchChanged,
                    ),
                  ),

                  // Category Chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
                      child: Obx(
                        () => CategoryChips(
                          selectedCategory: controller.selectedCategory.value,
                          onCategorySelected: controller.onCategorySelected,
                        ),
                      ),
                    ),
                  ),

                  // Wallpapers Grid / States
                  Obx(() {
                    if (controller.isLoading.value &&
                        controller.wallpapers.isEmpty) {
                      return const SliverFillRemaining(child: CustomLoading());
                    }

                    if (controller.hasError.value &&
                        controller.wallpapers.isEmpty) {
                      return SliverFillRemaining(
                        child: ErrorView(
                          message: controller.errorMessage.value,
                          onRetry: controller.retry,
                        ),
                      );
                    }

                    if (controller.wallpapers.isEmpty) {
                      return const SliverFillRemaining(
                        child: EmptyState(
                          title: 'No Wallpapers Found',
                          message: 'Try searching for something else',
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveUtil.gridColumns,
                          mainAxisSpacing: 16.w,
                          crossAxisSpacing: 16.w,
                          childAspectRatio: ResponsiveUtil.cardAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index >= controller.wallpapers.length) {
                              return const Center(
                                child: CustomLoading(size: 30),
                              );
                            }

                            return WallpaperCard(
                              wallpaper: controller.wallpapers[index],
                              index: index,
                            );
                          },
                          childCount:
                              controller.wallpapers.length +
                              (controller.isLoadingMore.value ? 2 : 0),
                        ),
                      ),
                    );
                  }),

                  // Bottom Spacing for keyboard/safearea
                  SliverPadding(padding: EdgeInsets.only(bottom: 20.h)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          // App Icon with gradient
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.wallpaper_rounded,
              color: Colors.white,
              size: 24.w,
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          SizedBox(width: 16.w),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallpaper Downloader',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Discover stunning images',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
          ),
          // Theme Toggle
          Obx(
            () => IconButton(
              onPressed: themeService.toggleTheme,
              icon: AnimatedSwitcher(
                duration: 300.ms,
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  themeService.isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey(themeService.isDarkMode),
                  color: Theme.of(context).iconTheme.color,
                  size: 26.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
