class DBCollections {
  static const String userCollection = "Users";
  static const String chatCollection = "Chats";
  static const String messagesCollection = "messages";
}

class ChatFields {
  static const String hasActivity = 'is_activity';
  static const String isGroup = 'is_group';
  static const String members = 'members';
  static const String messagesCollection = 'messages';
}

class UserFields {
  static const String name = 'name';
  static const String email = 'email';
  static const String imageUrl = 'image';
  static const String lastActive = 'last_active';
}

class MessageFields {
  static const String type = 'type';
  static const String content = 'content';
  static const String senderId = 'sender_id';
  static const String sentTime = 'sent_time';
}
