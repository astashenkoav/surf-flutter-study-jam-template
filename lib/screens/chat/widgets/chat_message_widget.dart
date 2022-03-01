import 'package:flutter/material.dart';
import '../../../data/chat/models/message.dart';
import '../../../data/chat/models/user.dart';
import '../../../utils/chat_utils.dart';
import '../../../utils/location_utils.dart';
import '../../../utils/messages_utils.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessageDto messageItem;

  const ChatMessageWidget({Key? key, required this.messageItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print(messageItem);
    final bool isLocation = messageItem is ChatMessageGeolocationDto ? true : false;
    final bool isMy = messageItem.author is ChatUserLocalDto ? true : false;
    final timeMessage = ChatUtils.getChatFormatTime(messageItem.createdDateTime);
    final List<Widget> message = [];

    if (messageItem.message.isNotEmpty) {
      message.add(const SizedBox(
        height: 5.0,
      ));
      message.add(Text(
        messageItem.message,
      ));
    }

    if (isLocation) {
      if (message.isNotEmpty) {
        message.add(const SizedBox(
          height: 5.0,
        ));
      }
      message.add(InkWell(
        child: const Text(
          MessagesUtils.chatMessageLocationLinkText,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        onTap: () {
          final messageLocation = messageItem as ChatMessageGeolocationDto;
          LocationUtils.launchMap(messageLocation.location.latitude, messageLocation.location.longitude);
        },
      ));
    }

    return Container(
      margin: isMy
          ? const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 40.0)
          : const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 40.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
      decoration: BoxDecoration(
        color: isMy ? const Color(0xfff0e8f7) : const Color(0xffe8f7ee),
        borderRadius: isMy
            ? const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
      ),
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
                RichText(
                  text: TextSpan(
                      text: messageItem.author.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        const TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                          text: timeMessage,
                          style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                        )
                      ]),
                  overflow: TextOverflow.ellipsis,
                ),
                ...message,
              ],
            ),
          )
        ],
      ),
    );
  }
}
