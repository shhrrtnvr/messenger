//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messagesCollection = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

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
