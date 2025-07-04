import 'package:event_connect/features/attendee/user_homescreen/data_access/user_homescreen_da.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class UserHomescreenBl {
  final _dataAccess = UserHomescreenDa();
  final _imageCaching = ImageCachingSetup();

  Future<String> getUserProfilePic() async {
    try {
      String imageUrl = await _dataAccess.getUserProfilePic();
      return await _imageCaching.downloadAndCacheImageByUrl(
          "$imageUrl${imageUrl.contains('?') ? '&' : '?'}updated=${DateTime.now().millisecondsSinceEpoch}");
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
