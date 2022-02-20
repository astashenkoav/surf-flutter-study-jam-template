import 'package:flutter/cupertino.dart';

import '../data/chat/models/message.dart';
import '../data/chat/repository/repository.dart';

class ChatModel extends ChangeNotifier {
  ChatRepository chatRepository;
  List<ChatMessageDto> listMessage = [];
  String localName = 'Astashenko';
  String message = '';
  bool loadingSendMessage = false;
  bool loadingMessage = true;

  ChatModel({required this.chatRepository}) {
    reloadListMessage();
  }

  void reloadListMessage() {
    final messages = chatRepository.messages;
    messages.then((value) {
      if (listMessage.isNotEmpty && value.isNotEmpty) {
        final endMessage = listMessage.first;
        for (final valItem in value) {
          if (valItem.createdDateTime.millisecondsSinceEpoch >= endMessage.createdDateTime.millisecondsSinceEpoch &&
              valItem.message != endMessage.message) {
            listMessage.insert(0, valItem);
          }
        }
      } else {
        listMessage.addAll(value);
      }

      loadingSendMessage = false;
      loadingMessage = false;
      notifyListeners();
    });
  }

  void sendMessage() async {
    loadingSendMessage = true;
    notifyListeners();
    if (message.isNotEmpty && localName.isNotEmpty) {
      await chatRepository.sendMessage(localName, message);
      reloadListMessage();
    }
  }
}

class ChatModelProvider extends InheritedNotifier {
  final ChatModel model;

  const ChatModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(key: key, child: child, notifier: model);

  static ChatModelProvider read(BuildContext context) {
    final InheritedElement? element = context.getElementForInheritedWidgetOfExactType<ChatModelProvider>();
    return element?.widget as ChatModelProvider;
  }

  static ChatModelProvider of(BuildContext context) {
    final ChatModelProvider? result = context.dependOnInheritedWidgetOfExactType<ChatModelProvider>();
    return result!;
  }
}
