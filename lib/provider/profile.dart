import 'package:flutter/cupertino.dart';
import 'dart:typed_data';
import 'package:fairticketsolutions_demo_app/models/user_model.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';

// Class to hold profile information and sync it throughout the application
class Profile with ChangeNotifier {
  Uint8List? _avatarBlob;
  String? _email;
  String _uid = "";

  void setAvatar(Uint8List? imageBlob) {
    _avatarBlob = imageBlob;
    notifyListeners();
  }

  Future<void> setAvatarToFirebase(StorageService storageService, BuildContext context, Uint8List? imageBlob) async {
    // These are first so as to not compromise on UI responsiveness
    _avatarBlob = imageBlob;
    notifyListeners();

    if (imageBlob == null) {
      await storageService.deleteFile(context, "avatar.jpeg");
    }
    else {
      await storageService.uploadFileFromBlob(context, imageBlob, "avatar.jpeg");
    }
  }

  Uint8List? getAvatar() {
    return _avatarBlob;
  }

  String? getEmail() {
    return _email;
  }

  String getUid() {
    return _uid;
  }

  void setProfileFromUser(User user) {
    _email = user.email;
    _uid = user.uid;
    notifyListeners();
  }
}

Profile profileProvider = Profile();