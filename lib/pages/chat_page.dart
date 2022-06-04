//Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat.dart';
import '../models/chat_message.dart';

//Provider
import '../providers/authentication_provider.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageListViewController;

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold();
  }
}
