import 'package:flutter/material.dart';

import 'MessageComponent/message_body.dart';

class MessagesScreen extends StatelessWidget {

  final String chatRoomID;
  final bool isHistory;

  const MessagesScreen({Key key, this.chatRoomID, this.isHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: MessageBody(chatRoomID: chatRoomID,isFromHistory: isHistory,),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          BackButton(),
          SizedBox(width: 20.0 * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kristin Watson",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "PPKU Staff",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}