import 'package:flutter/material.dart';

import '../../../utils/messages_utils.dart';
import '../chat_model.dart';

class LocationButtonWidget extends StatelessWidget {
  const LocationButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ChatModelProvider.of(context).model;

    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(MessagesUtils.locationAlertQuestion),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    model.setLocation();
                  },
                  child: const Text(MessagesUtils.locationAlertBtnTextYes),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    MessagesUtils.locationAlertBtnTextNo,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
              elevation: 24,
            );
          },
        );
      },
      padding: EdgeInsets.zero,
      splashRadius: Material.defaultSplashRadius / 2,
      constraints: const BoxConstraints(),
      icon: const Icon(
        Icons.share_location_outlined,
        color: Colors.deepPurple,
      ),
    );
  }
}
