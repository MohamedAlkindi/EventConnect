import 'dart:io';

import 'package:event_connect/core/models/event_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageCachingSetup {
  Future<void> downloadAndCacheImages(List<EventModel> eventModels) async {
    final dir = await getTemporaryDirectory();

    for (final event in eventModels) {
      if (event.pictureUrl.isNotEmpty &&
          Uri.tryParse(event.pictureUrl)?.isAbsolute == true) {
        final uri = Uri.parse(event.pictureUrl);
        final extension = uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last.split('.').last
            : 'jpg';
        final filename =
            'event_${event.eventID}_${event.cachedPicturePath.hashCode}.$extension';
        final file = File('${dir.path}/$filename');

        if (await file.exists()) {
          event.cachedPicturePath = file.path;
          continue;
        }

        try {
          final response = await http.get(Uri.parse(event.pictureUrl));
          if (response.statusCode == 200) {
            await file.writeAsBytes(response.bodyBytes);
            event.cachedPicturePath = file.path;
          }
        } catch (_) {
          // Optionally handle download errors
        }
      }
    }
  }

  Future<String> downloadAndCacheImageByUrl(String url) async {
    final dir = await getTemporaryDirectory();
    // Use a hash of the URL to ensure uniqueness and refresh on URL change
    final urlHash = url.hashCode;
    final extension = Uri.parse(url).pathSegments.isNotEmpty
        ? Uri.parse(url).pathSegments.last.split('.').last
        : 'jpg';
    final filename = 'cached_image_$urlHash.$extension';
    final file = File('${dir.path}/$filename');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      } else if (await file.exists()) {
        // Return cached file if download fails but cache exists
        return file.path;
      }
    } catch (_) {
      if (await file.exists()) {
        return file.path;
      }
      return url;
    }
    if (await file.exists()) {
      return file.path;
    }
    return url;
  }
}
