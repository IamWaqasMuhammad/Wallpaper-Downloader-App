import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../shared/widgets/custom_loading.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../controllers/home_controller.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_chips.dart';
import '../widgets/wallpaper_card.dart';

/// Beautiful home view with modern design and responsiveness
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
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
                  SliverToBoxAdapter(
                    child: _buildAppBar(context),
                  ),
                  
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
                      child: Obx(() => CategoryChips(
                        selectedCategory: controller.selectedCategory.value,
                        onCategorySelected: controller.onCategorySelected,
                      )),
                    ),
                  ),
                  
                  // Wallpapers Grid / States
                  Obx(() {
                    if (controller.isLoading.value && controller.wallpapers.isEmpty) {
                      return const SliverFillRemaining(
                        child: CustomLoading(),
                      );
                    }
                    
                    if (controller.hasError.value && controller.wallpapers.isEmpty) {
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
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
                          childCount: controller.wallpapers.length + 
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
                  color: AppColors.primary.withOpacity(0.3),
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
          Obx(() => IconButton(
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
          )),
        ],
      ),
    );
  }
}
