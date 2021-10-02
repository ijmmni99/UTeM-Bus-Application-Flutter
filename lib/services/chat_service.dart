import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:utem_bus_app/models/chat_messages.dart';
import 'package:utem_bus_app/models/chat_model.dart';

class ChatService {

  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference chat_model = FirebaseFirestore.instance.collection('hubungi');
  CollectionReference message_model = FirebaseFirestore.instance.collection('mesej');

  Future createChatRoom(Chat chats) async {
    try {
      DocumentReference ref =  await chat_model.doc(auth.currentUser.uid);

      String chatRoomID = DateTime.now().toIso8601String();;

      ref.set({
        "name" : chats.name,
        "lastMessage" : chats.lastMessage,
        "image" : chats.image,
        "isActive" : chats.isActive,
        "time" : chats.time,
        "chatRoomID" : chatRoomID,
        "status" : "notready"
      }).then((value) {
        ref.collection('history').add({
        "name" : chats.name,
        "lastMessage" : chats.lastMessage,
        "image" : chats.image,
        "isActive" : chats.isActive,
        "time" : chats.time,
        "chatRoomID" : chatRoomID,
        "status" : "done"
        });
      });
      return ref.id;
    }
    on FirebaseException catch (e) {
      return e.message;
    }
  }

  Future sendMessage(ChatMessage message, String chatRoomID) async{
    try {
      await message_model.doc(auth.currentUser.uid).collection(chatRoomID).doc(DateTime.now().toString()).set({
        "text" : message.text,
        "messageType" : message.messageType.toString(),
        "messageStatus" : message.messageStatus.toString(),
        "isSender" : message.isSender,
        "time" : DateTime.now()
      });
    }
    on FirebaseException catch (e) {
      return e.message;
    } 
  }
}