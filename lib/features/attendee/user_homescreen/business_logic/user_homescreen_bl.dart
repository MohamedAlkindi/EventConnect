import 'package:event_connect/core/exceptions/authentication_exceptions/authentication_exceptions.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class UserHomescreenBl {
  final _imageCaching = ImageCachingSetup();

  Future<String> getUserProfilePic() async {
    try {
      // String imageUrl = await _dataAccess.getUserProfilePic();
      return await _imageCaching
          .downloadAndCacheImageByUrl(globalUserModel!.profilePicUrl);
    } catch (e) {
      throw GenericException(e.toString());
    }
  }
}
