import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path_provider/path_provider.dart';

/// Download service for handling wallpaper downloads across platforms
class DownloadService {
  final http.Client _client = http.Client();

  /// Download image with progress tracking
  Future<bool> downloadImage({
    required String imageUrl,
    required int imageId,
    Function(double)? onProgress,
  }) async {
    try {
      if (kIsWeb) {
        return await _downloadForWeb(imageUrl, imageId, onProgress);
      } else if (Platform.isAndroid) {
        return await _downloadForAndroid(imageUrl, imageId, onProgress);
      } else if (Platform.isIOS) {
        return await _downloadForIOS(imageUrl, imageId, onProgress);
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  /// Web download implementation
  Future<bool> _downloadForWeb(
    String imageUrl,
    int imageId,
    Function(double)? onProgress,
  ) async {
    final response = await _downloadWithProgress(imageUrl, onProgress);

    await FileSaver.instance.saveFile(
      name: 'wallpaper_$imageId',
      bytes: response,
      ext: 'jpg',
      mimeType: MimeType.jpeg,
    );

    return true;
  }

  /// Android download implementation
  Future<bool> _downloadForAndroid(
    String imageUrl,
    int imageId,
    Function(double)? onProgress,
  ) async {
    // Check and request permission
    var hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      hasAccess = await Gal.requestAccess();
    }

    if (!hasAccess) {
      throw Exception('Gallery permission denied');
    }

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/wallpaper_$imageId.jpg';

    // Download image bytes with progress
    final bytes = await _downloadWithProgress(imageUrl, onProgress);

    // Save to temporary file
    final file = File(tempPath);
    await file.writeAsBytes(bytes);

    // Save to gallery
    await Gal.putImage(tempPath);

    // Clean up temp file
    if (await file.exists()) {
      await file.delete();
    }

    return true;
  }

  /// iOS download implementation
  Future<bool> _downloadForIOS(
    String imageUrl,
    int imageId,
    Function(double)? onProgress,
  ) async {
    // Similar to Android implementation
    var hasAccess = await Gal.hasAccess();
    if (!hasAccess) {
      hasAccess = await Gal.requestAccess();
    }

    if (!hasAccess) {
      throw Exception('Photo library permission denied');
    }

    final bytes = await _downloadWithProgress(imageUrl, onProgress);

    await Gal.putImageBytes(
      bytes,
      name: 'wallpaper_$imageId',
    );

    return true;
  }

  /// Helper method to download bytes with progress
  Future<Uint8List> _downloadWithProgress(
    String url,
    Function(double)? onProgress,
  ) async {
    final request = http.Request('GET', Uri.parse(url));
    final response = await _client.send(request);

    if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    }

    final int total = response.contentLength ?? -1;
    int received = 0;
    final List<int> bytes = [];

    await for (final List<int> chunk in response.stream) {
      bytes.addAll(chunk);
      received += chunk.length;
      if (total != -1 && onProgress != null) {
        onProgress(received / total);
      }
    }

    return Uint8List.fromList(bytes);
  }
}
