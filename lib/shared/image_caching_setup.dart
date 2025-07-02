import 'dart:io';

import 'package:event_connect/core/models/event_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageCachingSetup {
  Future<void> downloadAndCacheImages(List<EventModel> eventModels) async {
    final dir = await getTemporaryDirectory();

    for (final event in eventModels) {
      if (event.picture.isNotEmpty &&
          Uri.tryParse(event.picture)?.isAbsolute == true) {
        final filename = 'event_${event.eventID}.jpg';
        final file = File('${dir.path}/$filename');

        if (await file.exists()) {
          event.picture = file.path;
          continue;
        }

        try {
          final response = await http.get(Uri.parse(event.picture));
          if (response.statusCode == 200) {
            await file.writeAsBytes(response.bodyBytes);
            event.picture = file.path;
          }
        } catch (_) {
          // Optionally handle download errors
        }
      }
    }
  }

  Future<String> downloadAndCacheImageByUrl(String url) async {
    final dir = await getTemporaryDirectory();
    final filename = Uri.parse(url).pathSegments.isNotEmpty
        ? Uri.parse(url).pathSegments.last
        : 'cached_image.jpg';
    final file = File('${dir.path}/$filename');

    if (await file.exists()) {
      return file.path;
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file.path;
      }
    } catch (_) {
      return url;
    }
    return url;
  }
}
