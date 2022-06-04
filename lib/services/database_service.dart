//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

//Constants
import '../constants/db_fields.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService();

  Future<void> createUser(
      String _uid, String _email, String _name, String _imageUrl) async {
    try {
      await _db.collection(DBCollections.userCollection).doc(_uid).set(
        {
          UserFields.email: _email,
          UserFields.imageUrl: _imageUrl,
          UserFields.lastActive: DateTime.now().toUtc(),
          UserFields.name: _name,
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(DBCollections.userCollection).doc(_uid).get();
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db
        .collection(DBCollections.chatCollection)
        .where(ChatFields.members, arrayContains: _uid)
        .snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(DBCollections.chatCollection)
        .doc(_chatID)
        .collection(DBCollections.messagesCollection)
        .orderBy(MessageFields.sentTime, descending: true)
        .limit(1)
        .get();
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db
          .collection(DBCollections.userCollection)
          .doc(_uid)
          .update({UserFields.lastActive: DateTime.now().toUtc()});
    } catch (e) {
      print(e.toString());
    }
  }
}
