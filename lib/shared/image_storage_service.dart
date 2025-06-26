import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class ImageStorageService {
  Future<String> addAndReturnImageUrl(
      String imagePath, String eventName, String userID,
      {required bool isEventPic}) async {
    final file = File(imagePath);
    final imageExtension = imagePath.split(".").last;
    final storage = Supabase.instance.client.storage;

    if (isEventPic) {
      // this will be the default "name" for the file to be stored in the supabase and firebase.
      final path = 'events/$userID/$eventName.$imageExtension';

      await storage.from('event-pic-storage').upload(path, file);
      return storage.from('event-pic-storage').getPublicUrl(path);
    } else {
      // this will be to store user images to the firestore and supabase.
      final path = 'users/$userID';

      await storage.from('user-pic-storage').upload(path, file);
      return storage.from('user-pic-storage').getPublicUrl(path);
    }
  }
}
