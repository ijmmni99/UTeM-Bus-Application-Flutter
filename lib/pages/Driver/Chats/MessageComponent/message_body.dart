import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utem_bus_app/models/chat_messages.dart';
import 'package:utem_bus_app/shared/loading.dart';
import 'messages.dart';

import 'chat_input_field.dart';

class MessageBody extends StatelessWidget {
  final ScrollController _scrollController = new ScrollController();

  final String chatRoomID;
  final bool isFromHistory;

  MessageBody({Key key, this.chatRoomID, this.isFromHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('mesej')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection(chatRoomID)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Text("Error: ${snapshot.error}");

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Loading();
                      default:
                        return ListView.builder(
                            controller: _scrollController,
                            reverse: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              List<ChatMessage> chats = [];

                              snapshot.data.docs.forEach((element) {
                                  
                                ChatMessageType type;

                                if(element['messageType'] == "ChatMessageType.text")
                                  type = ChatMessageType.text;
                                
                                if(element['messageType'] == "ChatMessageType.audio")
                                  type = ChatMessageType.audio;

                                if(element['messageType'] == "ChatMessageType.video")
                                  type = ChatMessageType.video;

                                if(element['messageType'] == "ChatMessageType.image")
                                  type = ChatMessageType.image;

                                ChatMessage chatMessage = ChatMessage(
                                    time: element['time'].toDate(),
                                    isSender: element['isSender'],
                                    messageStatus: MessageStatus.viewed,
                                    messageType: type,
                                    text: element['text']);

                                chats.add(chatMessage);
                              });

                              final reversedIndex = chats.length - 1 - index;
                              return Message(message: chats[reversedIndex]);
                            });
                    }
                  })),
        ),
        isFromHistory ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          SizedBox(height: 20.0),
          Text('Ini Adalah Simpanan Laporan Hubungi Anda'),
          SizedBox(height: 20.0,)
        ],) : ChatInputField(chatRoomID: chatRoomID) ,
      ],
    );
  }
}
