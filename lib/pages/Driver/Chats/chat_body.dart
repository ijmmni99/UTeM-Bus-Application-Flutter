import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utem_bus_app/models/chat_model.dart';
import 'package:utem_bus_app/pages/Driver/Chats/chat_card.dart';
import 'package:utem_bus_app/pages/Driver/Chats/message.dart';
import 'package:utem_bus_app/shared/loading.dart';

class Body extends StatelessWidget {
  final DocumentSnapshot data;
  const Body({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('hubungi')
                  .doc(context.watch<User>().uid)
                  .collection('history')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text("Error: ${snapshot.error}");

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Loading();

                  default:
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          snapshot.data.docs.forEach((doc) {
                            Chat chats = new Chat(
                                image: data.data()['image'],
                                isActive: data.data()['isActive'],
                                lastMessage: data.data()['lastMessage'],
                                name: data.data()['name'],
                                time: data.data()['time'].toDate());

                            chatsData.add(chats);
                          });

                          return ChatCard(
                            chat: chatsData[index],
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MessagesScreen(chatRoomID: snapshot.data.docs[index]['chatRoomID'], isHistory: true,),
                              ),
                            ),
                          );
                        });
                }
              }),
        ),
      ],
    );
  }
}
