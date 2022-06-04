//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messagesCollection = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageUrl) async {
    try {
      await _db.collection(userCollection).doc(_uid).set(
        {
          "email": _email,
          "image": _imageUrl,
          "last_active": DateTime.now().toUtc(),
          "name": _name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(userCollection).doc(_uid).get();
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db
          .collection(userCollection)
          .doc(_uid)
          .update({"last_active": DateTime.now().toUtc()});
    } catch (e) {
      print(e.toString());
    }
  }
}
