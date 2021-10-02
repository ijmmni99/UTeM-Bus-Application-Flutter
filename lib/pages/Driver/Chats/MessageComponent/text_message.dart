import 'package:flutter/material.dart';
import 'package:utem_bus_app/models/chat_messages.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({
    Key key,
    this.message,
  }) : super(key: key);

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),
        onTap: () {},
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0 * 0.75,
            vertical: 20.0 / 2,
          ),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(message.isSender ? 1 : 0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            message.text,
            style: TextStyle(
              color: message.isSender
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
        ),
      ),
    );
  }
}