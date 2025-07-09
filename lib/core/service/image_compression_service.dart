import 'dart:developer' as log;
import 'dart:io';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:image/image.dart' as img;

class ImageCompressionService {
  Future<String> compressAndReplaceImage(String imagePath,
      {int quality = 70, int maxWidth = 800}) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw GenericException('Image file does not exist at the provided path.');
    }

    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw GenericException('Failed to decode image.');
    }

    // Resize if wider than maxWidth
    final resized =
        image.width > maxWidth ? img.copyResize(image, width: maxWidth) : image;
    log.log(image.width.toString());
    // Encode as JPEG with given quality
    final compressedBytes = img.encodeJpg(resized, quality: quality);
    log.log(resized.toString());
    // Overwrite the original file
    await file.writeAsBytes(compressedBytes, flush: true);

    return imagePath;
  }
}
