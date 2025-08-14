import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/features/attendee/my_profile/data_access/my_profile_da.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class MyProfileBL {
  final _dataAccess = MyProfileDa();
  final _user = FirebaseUser();
  final _imageCaching = ImageCachingSetup();

  Future<void> signOut() async {
    try {
      await _user.signOut();
      // Clear cached data and reset global variables
      await _imageCaching.clearAllCachedData();
    } catch (e) {
      throw GenericException("Error ${e.toString()}");
    }
  }

  Future<void> deleteUser() async {
    try {
      await _dataAccess.deleteUser();
      // Clear cached data and reset global variables
      await _imageCaching.clearAllCachedData();
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
