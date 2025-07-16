import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/attendee/my_profile/data_access/my_profile_da.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class MyProfileBL {
  final _dataAccess = MyProfileDa();
  final _imageCaching = ImageCachingSetup();
  final _user = FirebaseUser();

  Future<String> getUserPicAndLocation() async {
    try {
      final userPic = await _dataAccess.getUserPic();
      // Cache the image locally..
      final imagePath = await _imageCaching.downloadAndCacheImageByUrl(userPic);
      return imagePath;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _user.signOut();
    } catch (e) {
      throw GenericException("Error ${e.toString()}");
    }
  }

  Future<void> deleteUser() async {
    try {
      await _dataAccess.deleteUser();
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
