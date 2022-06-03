//Packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String userCollection = "Users";
const String chatCollection = "Chats";
const String messagesCollection = "Messages";

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
}
