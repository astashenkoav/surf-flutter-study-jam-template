import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

import '../data/chat/models/message.dart';
import '../data/chat/models/user.dart';
import 'chat_model.dart';

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
  late final ChatModel _model;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _model = ChatModel(chatRepository: widget.chatRepository);
  }

  @override
  Widget build(BuildContext context) {
    return ChatModelProvider(
      child: const ChatScreenBody(),
      model: _model,
    );
  }
}

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleTextBox(),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xfffffbfc),
                child: const _ContentBox(),
              ),
            ),
            const _BottomTextBox()
          ],
        ),
      ),
    );
  }
}

class _ContentBox extends StatelessWidget {
  const _ContentBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ChatModelProvider.of(context).model;
    final listMessage = model.listMessage;
    print('build ChatScreenBody');
    return model.loadingMessage
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            reverse: true,
            itemCount: listMessage.length,
            itemBuilder: (BuildContext context, int index) {
              return _MessageItem(messageItem: listMessage[index]);
            });
  }
}

class _TitleTextBox extends StatelessWidget {
  const _TitleTextBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ChatModelProvider.of(context).model;
    return Container(
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.white54,
              style: const TextStyle(color: Colors.white54),
              autofocus: false,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Введите ник',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              onChanged: (value) {
                model.localName = value;
              },
            ),
          ),
          IconButton(
            onPressed: () {
              model.reloadListMessage();
            },
            padding: EdgeInsets.zero,
            splashRadius: Material.defaultSplashRadius / 2,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.refresh),
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
    final model = ChatModelProvider.of(context).model;
    final _controller = TextEditingController();

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 2,
                offset: const Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
        ),
        Container(
          color: const Color(0xfffffbfc),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: 'Сообщение'),
                  onChanged: (value) {
                    model.message = value;
                  },
                ),
              ),
              model.loadingSendMessage
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: () {
                        final snackBar = SnackBar(
                          content: const Text('Yay! A SnackBar!'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );

                        // Find the ScaffoldMessenger in the widget tree
                        // and use it to show a SnackBar.
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        //_controller.clear();
                        //model.sendMessage();
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: Material.defaultSplashRadius / 2,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.send)),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageItem extends StatelessWidget {
  final ChatMessageDto messageItem;

  const _MessageItem({Key? key, required this.messageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(messageItem);

    final bool isMy = messageItem.author is ChatUserLocalDto ? true : false;

    return Container(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
      color: isMy ? const Color(0xfff0e8f7) : Colors.transparent,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 18.0),
            child: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.deepPurple,
              child: Text(
                messageItem.author.name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${messageItem.author.name} (${messageItem.createdDateTime.hour}:${messageItem.createdDateTime.minute}:${messageItem.createdDateTime.second})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  messageItem.message,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
