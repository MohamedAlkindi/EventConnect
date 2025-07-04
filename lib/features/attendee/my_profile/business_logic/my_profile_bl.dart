import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/attendee/my_profile/data_access/my_profile_da.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class MyProfileBL {
  final _dataAccess = MyProfileDa();
  final _imageCaching = ImageCachingSetup();
  final _user = FirebaseUser();

  Future<UserModel> getUserPicAndLocation() async {
    try {
      final userModel = await _dataAccess.getUserPicAndLocation();
      // Get the newest picture from supabase.
      final imagePath = await _imageCaching.downloadAndCacheImageByUrl(
          "${userModel.profilePic}${userModel.profilePic.contains('?') ? '&' : '?'}updated=${DateTime.now().millisecondsSinceEpoch}");
      userModel.profilePic = imagePath;
      return userModel;
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    await _user.signOut();
  }

  Future<void> deleteUser() async {
    try {
      await _dataAccess.deleteUser();
    } catch (e) {
      throw GenericException(message: e.toString());
    }
  }
}
