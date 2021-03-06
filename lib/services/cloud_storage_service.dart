import 'dart:io';

//Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

const String userCollection = "Users";

class CloudStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CloudStorageService();

  Future<String?> saveUserImageToStorage(
      String _uid, PlatformFile _file) async {
    try {
      Reference _ref =
          _storage.ref().child('images/users/$_uid/profile.${_file.extension}');
      UploadTask _task = _ref.putFile(File(_file.path));
      return await _task.then(
        (_result) => _result.ref.getDownloadURL(),
      );
    } catch (_) {
    }
  }

  Future<String?> saveChatImageToStorage(
      String _chatID, String _userID, PlatformFile _file) async {
    try {
      Reference _ref = _storage.ref().child(
          'images/chats/$_chatID/${_userID}_${Timestamp.now().microsecondsSinceEpoch}.${_file.extension}');
      UploadTask _task = _ref.putFile(File(_file.path));
      return await _task.then(
        (_result) => _result.ref.getDownloadURL(),
      );
    } catch (_) {
    }
  }
}
