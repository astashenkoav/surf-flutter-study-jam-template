import 'package:flutter/material.dart';
import '../../../utils/messages_utils.dart';
import '../chat_model.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ChatModelProvider.of(context).model;
    final _controller = TextEditingController();
    _controller.text = model.localName;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            cursorColor: Colors.white54,
            style: const TextStyle(color: Colors.white54),
            autofocus: false,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: MessagesUtils.chatTitleHintText,
              hintStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              model.localName = value;
            },
          ),
        ),
        IconButton(
          onPressed: () => model.reloadListMessage(),
          padding: EdgeInsets.zero,
          splashRadius: Material.defaultSplashRadius / 2,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
