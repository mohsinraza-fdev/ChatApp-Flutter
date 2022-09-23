import 'dart:async';

import 'package:chat_app/app/app.router.dart';
import 'package:chat_app/app/locator.dart';
import 'package:chat_app/models/conversation_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/services/app_firebase_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/views/add_contact/add_contact_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';

class HomeViewModel extends BaseViewModel {
  final fService = locator<AppFirebaseService>();
  final authService = locator<AuthService>();
  final chatService = locator<ChatService>();
  final navigator = locator<NavigationService>();

  String? get myUid => authService.user?.uid;
  String? get myEmail => authService.user?.email;

  List<Conversation> conversations = <Conversation>[];
  StreamSubscription? conversationStream;

  getData() async {
    setBusy(true);
    try {
      conversations = await fService.getAllConversations(myUid!);
      conversationStream = fService.connectToConversation(myUid!).listen((ds) {
        conversations = <Conversation>[];
        for (Map<String, dynamic> data in ds.get('conversations')) {
          conversations.add(Conversation.fromJson(data));
        }
        notifyListeners();
      });
    } catch (e) {
      null;
    }

    setBusy(false);
    // messages = await fService.getMessages();
    // stream = fService.streamMessages().listen((event) {
    //   List<Message> streamMessages = <Message>[];
    //   for (DocumentSnapshot doc in event.docs) {
    //     streamMessages.add(
    //       Message(
    //           id: doc.get('id'),
    //           message: doc.get('message'),
    //           timeStamp:
    //               DateTime.fromMicrosecondsSinceEpoch(doc.get('timeStamp'))),
    //     );
    //   }
    //   streamMessages
    //       .sort((a, b) => a.timeStamp.isBefore(b.timeStamp) == true ? -1 : 1);
    //   messages = streamMessages;
    //   notifyListeners();
    // });
  }

  onDispose() {
    conversationStream?.cancel();
  }

  openChat(String id, String name) {
    chatService.currentConversationId = id;
    chatService.currentConversationName = name;
    navigator.navigateTo(Routes.chatView);
  }

  showAddContactDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => const Center(
              child: AddContactView(),
            ),
        barrierDismissible: false);
  }
}
