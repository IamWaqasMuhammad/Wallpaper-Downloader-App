import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaper_downloader/core/constants/app_constants.dart';
import 'package:wallpaper_downloader/data/models/wallpaper_model.dart';
import 'package:wallpaper_downloader/data/providers/download_service.dart';
import 'package:wallpaper_downloader/data/repositories/wallpaper_repository.dart';

/// Home controller with clean business logic
class HomeController extends GetxController {
  final WallpaperRepository _repository;
  final DownloadService _downloadService;

  HomeController({
    WallpaperRepository? repository,
    DownloadService? downloadService,
  }) : _repository = repository ?? WallpaperRepository(),
       _downloadService = downloadService ?? DownloadService();

  // Observable state
  final wallpapers = <WallpaperModel>[].obs;
  final isLoading = true.obs;
  final isLoadingMore = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;
  final selectedCategory = ''.obs;

  // Downloading state per ID
  final downloadingIds = <int, double>{}.obs;

  // Pagination
  var currentPage = AppConstants.initialPage;

  // Controllers
  late ScrollController scrollController;
  final searchController = TextEditingController();

  // Debounce timer
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    fetchWallpapers();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  /// Scroll listener for infinite pagination
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && !hasError.value) {
        loadMore();
      }
    }
  }

  /// Fetch wallpapers (initial or refresh)
  Future<void> fetchWallpapers({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage = AppConstants.initialPage;
        wallpapers.clear();
      }

      isLoading.value = true;
      hasError.value = false;

      final response = await _repository.getWallpapers(
        query: searchQuery.value.isEmpty
            ? selectedCategory.value.isEmpty
                  ? AppConstants.defaultSearchQuery
                  : selectedCategory.value
            : searchQuery.value,
        page: currentPage,
      );

      if (response.isSuccess && response.data != null) {
        wallpapers.addAll(response.data!);
        hasError.value = false;
      } else {
        hasError.value = true;
        errorMessage.value = response.error ?? 'Failed to load wallpapers';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'An unexpected error occurred';
    } finally {
      isLoading.value = false;
    }
  }

  /// Load more wallpapers (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value) return;

    try {
      isLoadingMore.value = true;
      currentPage++;

      final response = await _repository.getWallpapers(
        query: searchQuery.value.isEmpty
            ? selectedCategory.value.isEmpty
                  ? AppConstants.defaultSearchQuery
                  : selectedCategory.value
            : searchQuery.value,
        page: currentPage,
      );

      if (response.isSuccess && response.data != null) {
        wallpapers.addAll(response.data!);
      }
    } catch (e) {
      currentPage--; // Revert page increment on error
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Handle search with debouncing
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(AppConstants.searchDebounce, () {
      searchQuery.value = query;
      selectedCategory.value = ''; // Clear category when searching
      currentPage = AppConstants.initialPage;
      wallpapers.clear();
      fetchWallpapers();
    });
  }

  /// Handle category selection
  void onCategorySelected(String category) {
    if (selectedCategory.value == category) return;

    selectedCategory.value = category;
    searchQuery.value = ''; // Clear search when selecting category
    searchController.clear();
    currentPage = AppConstants.initialPage;
    wallpapers.clear();
    fetchWallpapers();
  }

  /// Pull to refresh
  Future<void> onRefresh() async {
    await fetchWallpapers(isRefresh: true);
  }

  /// Retry on error
  void retry() {
    currentPage = AppConstants.initialPage;
    wallpapers.clear();
    fetchWallpapers();
  }

  /// Clear search state
  void clearSearch() {
    if (searchQuery.value.isNotEmpty) {
      searchQuery.value = '';
      searchController.clear();
      fetchWallpapers(isRefresh: true);
    }
  }

  /// Download wallpaper directly from card
  Future<void> downloadWallpaper(WallpaperModel wallpaper) async {
    if (downloadingIds.containsKey(wallpaper.id)) return;

    try {
      downloadingIds[wallpaper.id] = 0.0;

      final success = await _downloadService.downloadImage(
        imageUrl: wallpaper.src,
        imageId: wallpaper.id,
        onProgress: (progress) {
          downloadingIds[wallpaper.id] = progress;
        },
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Wallpaper saved to your gallery!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Download Failed',
        e.toString().contains('permission')
            ? 'Please grant storage permission'
            : 'Could not save wallpaper',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      // Remove from downloading state after a small delay
      await Future.delayed(const Duration(seconds: 2));
      downloadingIds.remove(wallpaper.id);
    }
  }
}
