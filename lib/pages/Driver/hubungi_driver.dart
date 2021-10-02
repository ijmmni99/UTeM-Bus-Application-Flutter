import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:utem_bus_app/models/chat_model.dart';
import 'package:utem_bus_app/services/chat_service.dart';
import 'package:utem_bus_app/shared/loading.dart';

import 'Chats/chat_body.dart';
import 'Chats/message.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('hubungi')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Loading();
            default:
              return snapshot.data.data() == null
                  ? RequestPPKUChat()
                  : snapshot.data['status'] == 'ready'
                      ? MessagesScreen(chatRoomID: snapshot.data['chatRoomID'], isHistory: false,)
                      : snapshot.data['status'] == 'done'
                          ? Scaffold(
                              appBar: buildAppBar(),
                              body: Body(
                                data: snapshot.data,
                              ),
                              floatingActionButton: FloatingActionButton(
                                onPressed: () async {
                                  Chat chats = new Chat(
                                      image: "assets/images/chat.png",
                                      isActive: false,
                                      lastMessage: " ",
                                      name: "PPKU Service",
                                      time: DateTime.now());

                                  await ChatService().createChatRoom(chats);
                                },
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.mark_chat_read_outlined,
                                  color: Colors.white,
                                ),
                              ))
                          : LoadingPPKUChat();
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.blue,
      title: Text("Hubungi"),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}

class RequestPPKUChat extends StatelessWidget {
  const RequestPPKUChat({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/images/chat.png"),
        SizedBox(height: size.height * 0.1),
        Text(
          "Dapatkan Khidmat PPKU melalui aplikasi ini.",
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 7.0),
        Text(
          "Tekan butang 'Request'.",
          style: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: size.height * 0.1),
        OutlinedButton(
            onPressed: () async {
              Chat chats = new Chat(
                  image: "assets/images/chat.png",
                  isActive: false,
                  lastMessage: " ",
                  name: "PPKU Service",
                  time: DateTime.now());

              await ChatService().createChatRoom(chats);
            },
            child: Text('Request'))
      ],
    )));
  }
}

class LoadingPPKUChat extends StatelessWidget {
  const LoadingPPKUChat({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Loading(),
            SizedBox(
              height: 20.0,
            ),
            Text('Requesting from PPKU...')
          ]),
    );
  }
}
