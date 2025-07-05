import 'package:event_connect/features/manager/manager_homescreen/data_access/manager_homescreen_da.dart';
import 'package:event_connect/shared/image_caching_setup.dart';

class ManagerHomescreenBl {
  final _dataAccess = ManagerHomescreenDa();
  final _imageCaching = ImageCachingSetup();

  Future<String> getManagerProfilePic() async {
    try {
      String imageUrl = await _dataAccess.getManagerProfilePic();
      return await _imageCaching.downloadAndCacheImageByUrl(
          "$imageUrl${imageUrl.contains('?') ? '&' : '?'}updated=${DateTime.now().millisecondsSinceEpoch}");
    } catch (e) {
      throw Exception("Error ${e.toString()}");
    }
  }
}
