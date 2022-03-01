import 'package:flutter/material.dart';
import '../../../utils/messages_utils.dart';
import '../chat_model.dart';
import 'location_button_widget.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ChatModelProvider.of(context).model;
    final _controller = TextEditingController();
    _controller.text = model.message;
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
              const LocationButtonWidget(),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(hintText: MessagesUtils.chatInputHintText),
                  onChanged: (value) => model.message = value,
                ),
              ),
              model.loadingSendMessage
                  ? const CircularProgressIndicator()
                  : IconButton(
                      onPressed: () {
                        _controller.clear();
                        model.sendMessage();
                      },
                      padding: EdgeInsets.zero,
                      splashRadius: Material.defaultSplashRadius / 2,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.send),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
