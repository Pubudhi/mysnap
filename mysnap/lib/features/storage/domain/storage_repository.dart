import 'dart:typed_data';

abstract class StorageRepository {
  //upload profile img on mobile
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  //upload profile img on web
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

  //upload post img on mobile
  Future<String?> uploadPostImageMobile(String path, String fileName);

  //upload post img on web
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
}
