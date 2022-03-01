import 'package:flutter/material.dart';

import 'package:surf_practice_chat_flutter/data/chat/repository/repository.dart';

import 'chat_model.dart';
import 'widgets/chat_message_widget.dart';
import 'widgets/footer_widget.dart';
import 'widgets/title_widget.dart';

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
      child: _ChatScreenBody(),
      model: _model,
    );
  }
}

class _ChatScreenBody extends StatelessWidget {
  _ChatScreenBody({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState?.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final model = ChatModelProvider.of(context).model;
    final listMessage = model.listMessage;
    if (model.errorMessage.isNotEmpty) {
      showSnackBar(model.errorMessage);
      model.errorMessage = '';
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const TitleWidget(),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: const Color(0xfffffbfc),
                child: model.loadingMessage
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemCount: listMessage.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChatMessageWidget(messageItem: listMessage[index]);
                        }),
              ),
            ),
            const FooterWidget()
          ],
        ),
      ),
    );
  }
}
