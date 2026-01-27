import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wallpaper_downloader/data/models/api_response.dart';
import 'package:wallpaper_downloader/data/models/wallpaper_model.dart';
import 'package:wallpaper_downloader/data/repositories/wallpaper_repository.dart';
import 'package:wallpaper_downloader/modules/home/controllers/home_controller.dart';

@GenerateNiceMocks([MockSpec<WallpaperRepository>()])
import 'home_controller_test.mocks.dart';

void main() {
  late HomeController controller;
  late MockWallpaperRepository mockRepository;

  setUp(() {
    mockRepository = MockWallpaperRepository();
    controller = HomeController(repository: mockRepository);
  });

  group('HomeController Tests', () {
    test('Initial state is correct', () {
      expect(controller.isLoading.value, true);
      expect(controller.wallpapers.isEmpty, true);
      expect(controller.hasError.value, false);
    });

    test('fetchWallpapers sets wallpapers on success', () async {
      final wallpapers = [
        WallpaperModel(
          id: 1,
          url: '',
          photographer: 'Test',
          photographerUrl: '',
          src: '',
          srcMedium: '',
          width: 0,
          height: 0,
        )
      ];

      when(mockRepository.getWallpapers(query: anyNamed('query'), page: anyNamed('page')))
          .thenAnswer((_) async => ApiResponse.success(wallpapers));

      await controller.fetchWallpapers();

      expect(controller.isLoading.value, false);
      expect(controller.wallpapers.length, 1);
      expect(controller.hasError.value, false);
    });

    test('fetchWallpapers sets error on failure', () async {
      when(mockRepository.getWallpapers(query: anyNamed('query'), page: anyNamed('page')))
          .thenAnswer((_) async => ApiResponse.failure('Error'));

      await controller.fetchWallpapers();

      expect(controller.isLoading.value, false);
      expect(controller.hasError.value, true);
      expect(controller.errorMessage.value, 'Error');
    });

    test('onSearchChanged triggers search with debounce', () async {
      final wallpapers = <WallpaperModel>[];
      when(mockRepository.getWallpapers(query: anyNamed('query'), page: anyNamed('page')))
          .thenAnswer((_) async => ApiResponse.success(wallpapers));

      controller.onSearchChanged('new query');
      
      // Wait for debounce duration
      await Future.delayed(const Duration(milliseconds: 600));

      expect(controller.searchQuery.value, 'new query');
      verify(mockRepository.getWallpapers(query: 'new query', page: 1)).called(1);
    });
  });
}
