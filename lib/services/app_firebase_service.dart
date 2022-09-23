import 'dart:math';

import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked/stacked_annotations.dart';

@lazySingleton
class AppFirebaseService {
  final firestoreInstance = FirebaseFirestore.instance;

  CollectionReference get userCollection =>
      firestoreInstance.collection('users');
  CollectionReference get conversationCollection =>
      firestoreInstance.collection('conversations');

  Future<void> setupNewUser(String uid, String email) async {
    await userCollection
        .doc(uid)
        .set({'uid': uid, 'email': email, 'conversations': []});
  }

  Future<void> addUser(String myUid, String myEmail, String friendEmail) async {
    try {
      DocumentSnapshot checkDoc = await userCollection.doc(myUid).get();
      List checkConvos = checkDoc.get('conversations');
      for (var item in checkConvos) {
        if (item['name'] == friendEmail) {
          return;
        }
      }

      QuerySnapshot friendUser =
          await userCollection.where('email', isEqualTo: friendEmail).get();
      DocumentSnapshot ds = friendUser.docs[0];
      String friendUid = ds.get('uid');

      DocumentReference newConvo = await conversationCollection.add({
        'participants': [
          {'uid': myUid, 'email': myEmail},
          {'uid': friendUid, 'email': friendEmail}
        ]
      });

      DocumentSnapshot myDoc = await userCollection.doc(myUid).get();
      List myConvos = myDoc.get('conversations');
      myConvos.add({'name': friendEmail, 'id': newConvo.id});
      await userCollection.doc(myUid).update({'conversations': myConvos});

      DocumentSnapshot friendDoc = await userCollection.doc(friendUid).get();
      List friendConvos = friendDoc.get('conversations');
      friendConvos.add({'name': myEmail, 'id': newConvo.id});
      await userCollection
          .doc(friendUid)
          .update({'conversations': friendConvos});
    } catch (e) {
      throw (e.toString());
    }
  }

  Stream<QuerySnapshot> connectToChat(String id) {
    return conversationCollection.doc(id).collection('messages').snapshots();
  }

  getNewMessageId(String convoId) {
    return conversationCollection.doc(convoId).collection('messages').doc().id;
  }

  sendMessage(CloudMessage message, String convoId) {
    conversationCollection
        .doc(convoId)
        .collection('messages')
        .doc(message.id)
        .set(message.toJson());
  }

  Stream<DocumentSnapshot> connectToConversation(String uid) {
    return userCollection.doc(uid).snapshots();
  }

  Future<List<Conversation>> getAllConversations(String uid) async {
    try {
      List<Conversation> conversations = <Conversation>[];
      DocumentSnapshot document = await userCollection.doc(uid).get();
      for (Map<String, dynamic> data in document.get('conversations')) {
        conversations.add(Conversation.fromJson(data));
      }
      return conversations;
    } catch (e) {
      print(e.toString());
      throw (e.toString());
    }
  }

  Future<DocumentSnapshot> getConversationData(String id) async {
    return await conversationCollection.doc(id).get();
  }

  Future<QuerySnapshot> getAllMessages(String convoId) async {
    return await conversationCollection
        .doc(convoId)
        .collection('messages')
        .get();
  }

  Stream<QuerySnapshot> streamMessages() {
    final CollectionReference collection =
        firestoreInstance.collection('messages');
    return collection.snapshots();
  }

  Future<List<Message>> getMessages() async {
    List<Message> messages = <Message>[];

    final CollectionReference collection =
        firestoreInstance.collection('messages');
    QuerySnapshot snapshot = await collection.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      messages.add(
        Message(
            id: doc.get('id'),
            message: doc.get('message'),
            timeStamp:
                DateTime.fromMicrosecondsSinceEpoch(doc.get('timeStamp'))),
      );
    }
    messages.sort((a, b) => a.timeStamp.isBefore(b.timeStamp) == true ? -1 : 1);
    return messages;
  }

  void generateRandomMessage() async {
    Random randomNumber = Random();
    final CollectionReference collection =
        firestoreInstance.collection('messages');
    await collection.add({
      'id': randomNumber.nextInt(10000),
      'message': 'Generated New Message With Random Id',
      'timeStamp': DateTime.now().microsecondsSinceEpoch,
    });
  }
}
