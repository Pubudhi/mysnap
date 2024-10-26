import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mysnap/features/storage/domain/storage_repository.dart';

class FirbaseStorageRepository implements StorageRepository {
  final FirebaseStorage stotage = FirebaseStorage.instance;

  ///
  /// Image upload
  ///

  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    //todo:make profile_images as global varibale
    return _uploadFile(path, fileName, "profile_images");
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "profile_images");
  }

  ///
  /// Post upload
  ///

  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, "post_images");
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, "post_images");
  }

  //mobile platform helper
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      //get file
      final file = File(path);

      //find place to store
      final storageRef = stotage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await storageRef.putFile(file);

      //get image download url
      final downloadurl = await uploadTask.ref.getDownloadURL();

      return downloadurl;
    } catch (e) {
      //todo:
      return null;
    }
  }

  // web platform helper
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {
      //find place to store
      final storageRef = stotage.ref().child('$folder/$fileName');

      //upload
      final uploadTask = await storageRef.putData(fileBytes);

      //get image download url
      final downloadurl = await uploadTask.ref.getDownloadURL();

      return downloadurl;
    } catch (e) {
      //todo:
      return null;
    }
  }


}
