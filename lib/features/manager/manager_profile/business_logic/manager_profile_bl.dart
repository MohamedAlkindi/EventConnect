import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/core/firebase/user/firebase_user.dart';
import 'package:event_connect/core/models/user_model.dart';
import 'package:event_connect/features/manager/manager_profile/data_access/manager_profile_da.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class ManagerProfileBl {
  final _dataAccess = ManagerProfileDa();
  final _imageCaching = ImageCachingSetup();
  final _user = FirebaseUser();

  Future<UserModel> getManagerPicAndLocation() async {
    try {
      final managerModel = await _dataAccess.getManagerPicAndLocation();
      final imagePath = await _imageCaching
          .downloadAndCacheImageByUrl(managerModel.profilePicUrl);
      managerModel.cachedPicturePath = imagePath;
      return managerModel;
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _user.signOut();
  }

  Future<void> deleteUser() async {
    try {
      await _dataAccess.deleteUser();
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
