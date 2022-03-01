import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/chat/models/geolocation.dart';
import '../../data/chat/models/message.dart';
import '../../data/chat/repository/repository.dart';
import '../../utils/location_utils.dart';

class ChatModel extends ChangeNotifier {
  ChatRepository chatRepository;
  List<ChatMessageDto> listMessage = [];
  String localName = '';
  String message = '';
  bool loadingSendMessage = false;
  bool loadingMessage = true;
  String errorMessage = '';
  bool sendLocation = false;
  List<double> location = [];

  ChatModel({required this.chatRepository}) {
    reloadListMessage();
  }

  void reloadListMessage() {
    final messages = chatRepository.messages;
    messages.then((value) {
      if (listMessage.isNotEmpty && value.isNotEmpty) {
        final endMessage = listMessage.first;
        for (final valItem in value) {
          if (valItem.createdDateTime.millisecondsSinceEpoch > endMessage.createdDateTime.millisecondsSinceEpoch) {
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
    try {
      if (sendLocation) {
        ChatGeolocationDto chatLocation = ChatGeolocationDto(latitude: location[0], longitude: location[1]);
        await chatRepository.sendGeolocationMessage(
            nickname: localName, location: chatLocation, message: message.isNotEmpty ? message : null);
      } else {
        await chatRepository.sendMessage(localName, message);
      }
      message = '';
      reloadListMessage();
    } on InvalidNameException catch (error) {
      sendErrorMessage(error.message);
    } on InvalidMessageException catch (error) {
      sendErrorMessage(error.message);
    } catch (error) {
      sendErrorMessage('$error');
    } finally {
      sendLocation = false;
    }
  }

  void sendErrorMessage(String message) {
    errorMessage = message;
    loadingSendMessage = false;
    loadingMessage = false;
    notifyListeners();
  }

  void setLocation() async {
    try {
      if (location.isEmpty) {
        Position position = await LocationUtils.getCurrentPosition();
        location.add(position.latitude);
        location.add(position.longitude);
      }
      sendLocation = true;
    } catch (error) {
      sendErrorMessage('$error');
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
