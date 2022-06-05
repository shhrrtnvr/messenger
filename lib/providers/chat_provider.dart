import 'dart:async';

//Packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';

//Providers
import '../providers/authentication_provider.dart';

//Models
import '../models/chat_message.dart';

//Constants
import '../constants/db_fields.dart';

class ChatProvider extends ChangeNotifier {
  late DatabaseService _db;
  late CloudStorageService _storage;
  late MediaService _media;
  late NavigationService _navigation;

  final AuthenticationProvider _auth;
  final ScrollController _scrollController;

  final String _chatID;
  List<ChatMessage>? messages;

  late StreamSubscription _messagesStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController _keyboardVisibilityController;

  String? _message;

  String get message {
    return _message ?? "";
  }

  set message(String _value) {
    _message = _value;
  }

  // void set message(String _value) {
  //   _message = _value;
  // }

  ChatProvider(this._chatID, this._auth, this._scrollController) {
    _db = GetIt.instance.get<DatabaseService>();
    _storage = GetIt.instance.get<CloudStorageService>();
    _media = GetIt.instance.get<MediaService>();
    _navigation = GetIt.instance.get<NavigationService>();
    _keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessages();
    listenToKeyboardChanges();
  }

  @override
  void dispose() {
    _messagesStream.cancel();
    super.dispose();
  }

  void listenToMessages() {
    try {
      _messagesStream = _db.streamMessagesForChat(_chatID).listen(
        (_snapshot) {
          List<ChatMessage> _messages = _snapshot.docs.map((_message) {
            Map<String, dynamic> _messageData =
                _message.data() as Map<String, dynamic>;
            return ChatMessage.fromJSON(_messageData);
          }).toList();
          _messages.sort((a, b) => a.sentTime.compareTo(b.sentTime));
          messages = _messages;
          notifyListeners();
          WidgetsBinding.instance!.addPostFrameCallback(
            (timeStamp) {
              if (_scrollController.hasClients) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              }
            },
          );
        },
      );
    } catch (_) {
    }
  }

  void listenToKeyboardChanges() {
    _keyboardVisibilityStream =
        _keyboardVisibilityController.onChange.listen((_event) {
      _db.updateChatData(
        _chatID,
        {ChatFields.hasActivity: _event},
      );
    });
  }

  void sendTextMessage() {
    if (_message != null) {
      ChatMessage _messageToSend = ChatMessage(
        content: _message!,
        type: MessageType.text,
        senderID: _auth.user.uid,
        sentTime: DateTime.now(),
      );
      _db.addMessageToChat(_chatID, _messageToSend);
    }
  }

  void sendImageMessage() async {
    try {
      PlatformFile? _file = await _media.pickImageFromLibrary();
      if (_file != null) {
        String? _downloadURL = await _storage.saveChatImageToStorage(
            _chatID, _auth.user.uid, _file);
        ChatMessage _messageToSend = ChatMessage(
          content: _downloadURL!,
          type: MessageType.image,
          senderID: _auth.user.uid,
          sentTime: DateTime.now(),
        );
        _db.addMessageToChat(_chatID, _messageToSend);
      }
    } catch (_) {
    }
  }

  void deleteChat() {
    goBack();
    _db.deleteChat(_chatID);
  }

  void goBack() {
    _navigation.goBack();
  }
}
