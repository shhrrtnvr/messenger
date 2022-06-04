//Packages
import 'package:flutter/material.dart';
import 'package:messenger/widgets/custom_input_field.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

//Models
import '../models/chat.dart';
import '../models/chat_message.dart';

//Provider
import '../providers/authentication_provider.dart';
import '../providers/chat_provider.dart';

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
  late ChatProvider _pageProvider;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(
          create: (context) =>
              ChatProvider(widget.chat.uid, _auth, _scrollController),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext _context) {
        _pageProvider = _context.watch<ChatProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight,
              width: _deviceWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TopBar(
                    widget.chat.title(),
                    fontSize: 12,
                    primaryAction: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromRGBO(0, 92, 218, 1.0),
                      ),
                      onPressed: () {},
                    ),
                    secondaryAction: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 221, 1.0),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  _messageListView(),
                  _sendMessageForm()
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _messageListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return Container(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
            itemCount: _pageProvider.messages!.length,
            itemBuilder: (BuildContext _context, int _idx) {
              ChatMessage _message = _pageProvider.messages![_idx];
              bool _isOwnMessage = _message.senderID == _auth.user.uid;
              return Container(
                child: CustomChatListViewTile(
                  deviceHeight: _deviceHeight,
                  width: _deviceWidth * 0.80,
                  message: _message,
                  isOwnMessage: _isOwnMessage,
                  sender: widget.chat.members
                      .where((_member) => _member.uid == _message.senderID)
                      .first,
                ),
              );
            },
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Say Hi!',
            style: TextStyle(color: Colors.white),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: Color.fromARGB(199, 85, 151, 221),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _messageTextField(),
            _sendMessageButton(),
            _imageMessageButton(),
          ],
        ),
      ),
    );
  }

  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
        onSaved: (_value) {
          _pageProvider.message = _value;
        },
        regEx: r"^(?!\s*$).+",
        hintText: 'Type a message',
        obscureText: false,
      ),
    );
  }

  Widget _sendMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if (_messageFormState.currentState!.validate()) {
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _imageMessageButton() {
    double _size = _deviceHeight * 0.04;
    return Container(
      height: _size,
      width: _size,
      child: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(
          0,
          82,
          218,
          1.0,
        ),
        onPressed: () {
          _pageProvider.sendImageMessage();
        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
}
