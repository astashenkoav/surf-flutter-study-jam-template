import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

import '../data/chat/models/message.dart';

/// Chat screen templete. This is your starting point.
class ChatScreen extends StatefulWidget {
  final ChatRepository chatRepository;

  const ChatScreen({
    Key? key,
    required this.chatRepository,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessageDto> listMessage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final messages = widget.chatRepository.messages;
    messages.then((value) {
      listMessage.addAll(value);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO(task): Use ChatRepository to implement the chat.
    return Scaffold(
      appBar: AppBar(
        title: _TitleTextBox(),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: ListView.builder(
                    reverse: true,
                    itemCount: listMessage.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = listMessage[index];
                      return MessageItem(messageItem: item);
                    }),
              ),
            ),
            _BottomTextBox()
          ],
        ),
      ),
    );
  }
}

class _TitleTextBox extends StatelessWidget {
  const _TitleTextBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.white54,
              style: TextStyle(color: Colors.white54),
              autofocus: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Введите ник',
                hintStyle: TextStyle(color: Colors.grey),
              ),
/*                  onEditingComplete: () {
                    print('onEditingComplete name');
                  },*/
              onChanged: (value) {
                print('change name');
              },
            ),
          ),
          IconButton(
            onPressed: () {
              print('refresh');
            },
            padding: EdgeInsets.zero,
            splashRadius: Material.defaultSplashRadius / 2,
            constraints: BoxConstraints(),
            icon: Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}

class _BottomTextBox extends StatelessWidget {
  const _BottomTextBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(hintText: 'Сообщение'),
              onChanged: (value) {
                print('change message');
              },
            ),
          ),
          IconButton(
              onPressed: () {
                print('message send');
              },
              padding: EdgeInsets.zero,
              splashRadius: Material.defaultSplashRadius / 2,
              constraints: BoxConstraints(),
              icon: Icon(Icons.send)),
        ],
      ),
    );
  }
}

class MessageItem extends StatelessWidget {
  final ChatMessageDto messageItem;

  const MessageItem({Key? key, required this.messageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(messageItem.author.name);
    return Container(
      child: Row(
        children: [
          Container(
            child: Text(messageItem.author.name.substring(0, 1).toUpperCase()),
          ),
          Column(
            children: [Text('avtor'), Text('message')],
          )
        ],
      ),
    );
  }
}
