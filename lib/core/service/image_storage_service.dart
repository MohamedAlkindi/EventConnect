import 'dart:io';

import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageStorageService {
  // I return the image url to use it later to update the image.
  Future<String> addAndReturnImageUrl(
      {required String imagePath,
      required eventName,
      required String userID,
      required bool isEventPic}) async {
    final file = File(imagePath);
    final imageExtension = imagePath.split(".").last;
    // Randomize it so it becomes unique for every pic.
    // Will be later used as the path for the image.
    final randomId = DateTime.now().microsecondsSinceEpoch.toString();
    final storage = Supabase.instance.client.storage;

    if (isEventPic) {
      // this will be the default "name" for the file to be stored in the supabase and firebase.
      final path = 'events/$userID/$randomId.$imageExtension';

      await storage.from('event-pic-storage').upload(path, file);
      return storage.from('event-pic-storage').getPublicUrl(path);
    } else {
      // this will be to store user images to the firestore and supabase.
      final path = 'users/$userID';

      await storage.from('user-pic-storage').upload(path, file);
      return storage.from('user-pic-storage').getPublicUrl(path);
    }
  }

  // dont return anything as the URL is already unique so it wont be changed.
  // newImagePath in the device. which will be the new image to be updated.
  // imageURL which is the saved url in supabase.
  Future<String> updateAndReturnImageUrl({
    // ImageUrl and userID are optional because if the user updates the event userID will be null.
    // Otherwise if the user will update the user profile pic, then the imageUrl will be null.
    required String newImagePath,
    required String? eventImageUrl,
    required String? userID,
    required bool isEventPic,
  }) async {
    final file = File(newImagePath);
    final storage = Supabase.instance.client.storage;

    if (isEventPic && eventImageUrl != null) {
      // this will take the full url and get the needed bit of it.
      final path = eventImageUrl.split('/').sublist(6).join('/');
      await storage.from('event-pic-storage').upload(path, file,
          fileOptions: const FileOptions(
            upsert: true,
          ));
      // Just return the same url, as it'll not be changed
      // The only thing will be changed is the content not the url path.
      return eventImageUrl;
      // return storage.from('event-pic-storage').getPublicUrl(path);
    } else {
      if (userID != null) {
        final path = 'users/$userID';
        await storage.from('user-pic-storage').upload(path, file,
            fileOptions: const FileOptions(
              upsert: true,
            ));
        return storage.from('user-pic-storage').getPublicUrl(path);
      } else {
        throw GenericException("Error:: user id cannot be empty");
      }
    }
  }
}
