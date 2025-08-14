import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/features/manager/manager_profile/data_access/manager_profile_da.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class ManagerProfileBl {
  final _dataAccess = ManagerProfileDa();
  final _imageCaching = ImageCachingSetup();

  Future<void> signOut() async {
    try {
      await _dataAccess.signOut();
      // Clear cached data and reset global variables
      await _imageCaching.clearAllCachedData();
    } catch (e) {
      throw GenericException(e.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      print('ManagerProfileBl: Starting delete user process...');
      await _dataAccess.deleteUser();
      print(
          'ManagerProfileBl: Delete user successful, clearing cached data...');
      // Clear cached data and reset global variables
      await _imageCaching.clearAllCachedData();
      print('ManagerProfileBl: Cached data cleared successfully');
    } catch (e) {
      print('ManagerProfileBl: Delete user failed with error: $e');
      throw GenericException(e.toString());
    }
  }
}
