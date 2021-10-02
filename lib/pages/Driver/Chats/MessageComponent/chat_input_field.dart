import 'package:flutter/material.dart';
import 'package:utem_bus_app/models/chat_messages.dart';
import 'package:utem_bus_app/services/chat_service.dart';

class ChatInputField extends StatefulWidget {

  final String chatRoomID;

  ChatInputField({Key key, this.chatRoomID}) : super(key: key);
  
  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {

  final inputText = TextEditingController();
  FocusNode textFocus;


  @override
  void initState() {
    super.initState();

    textFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    textFocus.dispose();
    inputText.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0 / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 32,
            color: Color(0xFF087949).withOpacity(0.08),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.mic, color: Colors.blueAccent),
            SizedBox(width: 20.0),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0 * 0.75,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.sentiment_satisfied_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: 20.0 / 4),
                    Expanded(
                      child: TextField(
                        focusNode: textFocus,
                        controller: inputText,
                        onSubmitted: (chats) async {
                          
                          ChatMessage message = new ChatMessage(
                             messageType: ChatMessageType.text,
                             isSender: true,
                             messageStatus: MessageStatus.viewed,
                             text: chats,
                             time: DateTime.now()
                          );

                          textFocus.requestFocus();

                          await ChatService().sendMessage(message, widget.chatRoomID).then((value) {
                            inputText.clear();
                          });
                          
                        },
                        decoration: InputDecoration(
                          hintText: "Type message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.attach_file,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.64),
                    ),
                    SizedBox(width: 20.0 / 4),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .color
                          .withOpacity(0.64),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}