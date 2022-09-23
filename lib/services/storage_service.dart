import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'dart:typed_data';

// Get and store user-related files, typically for profile picture
class StorageService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  late String _uid;

  void setUid() {
    _uid = _firebaseAuth.currentUser!.uid;
  }

  Future<void> uploadFileFromBlob(BuildContext context, Uint8List blob, String fileName) async {
    try {
      var storageRef = FirebaseStorage.instance.ref();
      var uploadTask = storageRef.child("$_uid/$fileName").putData(blob);
      var taskSnapshot = await uploadTask.whenComplete(() => null);

      taskSnapshot.ref.getDownloadURL().then((value) => debugPrint("DONE FILE UPLOAD: $value"));
    }
    catch (e) {
      debugPrint("ERROR UPLOADING FILE $fileName: $e");
    }
  }

  Future<void> deleteFile(BuildContext context, String fileName) async {
    try {
      await FirebaseStorage.instance.ref().child("$_uid/$fileName").delete();
    }
    catch (e) {
      debugPrint("ERROR DELETING FILE $fileName: $e");
    }
  }

  Future<Uint8List?> getBlob(BuildContext context, String fileName) async {
    try {
      return await FirebaseStorage.instance.ref().child("$_uid/$fileName").getData();
    }
    catch (e) {
      debugPrint("ERROR GETTING FILE $fileName: $e");

      return null;
    }
  }
}