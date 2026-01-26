import 'package:get/get.dart';
import 'package:wallpaper_downloader/modules/detail/bindings/detail_binding.dart';
import 'package:wallpaper_downloader/modules/detail/views/detail_view.dart';
import 'package:wallpaper_downloader/modules/home/bindings/home_binding.dart';
import 'package:wallpaper_downloader/modules/home/views/home_view.dart';
import 'package:wallpaper_downloader/routes/app_routes.dart';

/// GetX page configuration with bindings
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.detail,
      page: () => const DetailView(),
      binding: DetailBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
