//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

//Models
import '../models/chat_message.dart';

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
    } catch (_) {
    }
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = _db.collection(DBCollections.userCollection);
    if (name != null) {
      _query = _query
          .where(UserFields.name, isGreaterThanOrEqualTo: name)
          .where(UserFields.name, isLessThanOrEqualTo: name + "z");
    }
    return _query.get();
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

  Stream<QuerySnapshot> streamMessagesForChat(String _chatID) {
    return _db
        .collection(DBCollections.chatCollection)
        .doc(_chatID)
        .collection(DBCollections.messagesCollection)
        .orderBy(MessageFields.sentTime, descending: true)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatID, ChatMessage _message) async {
    try {
      await _db
          .collection(DBCollections.chatCollection)
          .doc(_chatID)
          .collection(DBCollections.messagesCollection)
          .add(
            _message.toJson(),
          );
    } catch (_) {
    }
  }

  Future<void> updateChatData(
      String _chatID, Map<String, dynamic> _data) async {
    try {
      await _db
          .collection(DBCollections.chatCollection)
          .doc(_chatID)
          .update(_data);
    } catch (_) {
    }
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db
          .collection(DBCollections.userCollection)
          .doc(_uid)
          .update({UserFields.lastActive: DateTime.now().toUtc()});
    } catch (_) {
    }
  }

  Future<void> deleteChat(String _chatID) async {
    try {
      await _db.collection(DBCollections.chatCollection).doc(_chatID).delete();
    } catch (_) {
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      DocumentReference _chat =
          await _db.collection(DBCollections.chatCollection).add(_data);
      return _chat;
    } catch (_) {
    }
  }
}
