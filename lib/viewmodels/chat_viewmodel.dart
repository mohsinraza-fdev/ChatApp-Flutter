import 'dart:async';
import 'dart:io';

import 'package:chat_app/app/locator.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/local_storage_service.dart';
import 'package:chat_app/views/send_file/send_file_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../services/app_firebase_service.dart';

class ChatViewModel extends BaseViewModel {
  final chatService = locator<ChatService>();
  final fService = locator<AppFirebaseService>();
  final authService = locator<AuthService>();
  final localStorageService = locator<LocalStorageService>();

  String? get myUid => authService.user?.uid;
  String? get myEmail => authService.user?.email;
  String? get convoId => chatService.currentConversationId;
  String? get friendUid => participants
      ?.firstWhere((participant) => participant['uid'] != myUid)['uid'];

  List<String> downlaodingFiles = <String>[];

  List<dynamic>? participants;
  List<CloudMessage>? messages;
  List<CloudMessage> bufferMessages = <CloudMessage>[];
  Map<String, dynamic> registry = <String, dynamic>{};

  StreamSubscription? conversationStream;
  TextEditingController messageController = TextEditingController();

  initializeChatBox() async {
    setBusy(true);
    if (convoId != null) {
      downlaodingFiles = localStorageService.loadDownloadingFiles();
      registry = localStorageService.getFileRegistryData();
      DocumentSnapshot ds = await fService.getConversationData(convoId!);
      participants = await ds.get('participants');
      messages = getRefinedMessages(await fService.getAllMessages(convoId!));

      conversationStream =
          fService.connectToChat(convoId!).listen((rawMessages) {
        messages = getRefinedMessages(rawMessages);
        notifyListeners();
      });
    } else {
      // Navigate back
    }
    setBusy(false);
  }

  bool checkFilePathExistance(String path) {
    try {
      if (registry.keys.contains(path)) {
        return true;
      }
    } catch (e) {
      null;
    }
    return false;
  }

  sendMessage(String text) {
    CloudMessage message = CloudMessage(
        id: fService.getNewMessageId(convoId!),
        from: myUid!,
        to: friendUid!,
        timeStamp: DateTime.now(),
        message: text);
    fService.sendMessage(message, convoId!);
    messageController.clear();
  }

  downloadFile(String messageId) async {
    CloudMessage message =
        messages!.firstWhere((element) => element.id == messageId);
    downlaodingFiles.add(messageId);
    notifyListeners();
    await localStorageService.saveDownloadingFiles(downlaodingFiles);
    final dir = await getApplicationDocumentsDirectory();
    String savePath =
        '${dir.path}/${message.fileName}${DateTime.now().millisecondsSinceEpoch}';
    File file = File(savePath);
    // Reference ref = FirebaseStorage.instance.ref().child(message.filePath!);
    // await ref.writeToFile(file);
    await Dio().download(message.filePath!, file.path);
    await localStorageService.addFileToRegistry(message.filePath!, file.path);
    registry = localStorageService.getFileRegistryData();

    await localStorageService.removeDownloadingFile(messageId);
    downlaodingFiles = localStorageService.loadDownloadingFiles();
    notifyListeners();
  }

  isFileDownloading(String messageId) {
    if (downlaodingFiles.contains(messageId)) {
      return true;
    }
    return false;
  }

  getRefinedMessages(QuerySnapshot rawMessages) {
    QuerySnapshot qs = rawMessages;
    List<CloudMessage> messages = <CloudMessage>[];
    for (DocumentSnapshot ds in qs.docs) {
      messages.add(CloudMessage.fromJson(ds.data() as Map<String, dynamic>));
    }
    return mergeBuffer(messages);
    // bufferMessages = localStorageService.loadBufferMessages();
    // for (CloudMessage message in messages) {
    //   bufferMessages
    //       .removeWhere((bufferMessage) => bufferMessage.id == message.id);
    // }
    // messages.addAll(bufferMessages);

    // messages.sort((a, b) => a.timeStamp.isBefore(b.timeStamp) == true ? 1 : -1);
    // return messages;
  }

  mergeBuffer(List<CloudMessage> messages) {
    bufferMessages = localStorageService.loadBufferMessages();
    for (CloudMessage message in messages) {
      bufferMessages
          .removeWhere((bufferMessage) => bufferMessage.id == message.id);
    }
    messages.addAll(bufferMessages);
    messages.sort((a, b) => a.timeStamp.isBefore(b.timeStamp) == true ? 1 : -1);
    if (bufferMessages.isEmpty) {
      localStorageService.clearBuffer();
    }
    return messages;
  }

  onDispose() {
    messageController.dispose();
    conversationStream?.cancel();
  }

  sendPhoto(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final res = await showDialog(
          context: context,
          builder: (BuildContext context) =>
              SendFileView(fileType: 'image', filePath: image.path));

      if (res == true) {
        String messageId = fService.getNewMessageId(convoId!);
        String refString = myUid! +
            friendUid! +
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference ref = FirebaseStorage.instance.ref().child(refString);

        CloudMessage message = CloudMessage(
            id: messageId,
            from: myUid!,
            to: friendUid!,
            timeStamp: DateTime.now(),
            message: '',
            fileName: image.name,
            filePath: null,
            fileType: 'image',
            buffered: true);

        await localStorageService.addMessageToBuffer(message);
        mergeBuffer(messages ?? <CloudMessage>[]);
        notifyListeners();
        await ref.putFile(File(image.path));
        String url = await ref.getDownloadURL();

        await localStorageService.addFileToRegistry(url, image.path);
        registry = localStorageService.getFileRegistryData();
        message.buffered = false;
        message.filePath = url;
        await fService.sendMessage(message, convoId!);
      }

      // Reference ref = FirebaseStorage.instance.ref().child(myUid! +
      //     friendUid! +
      //     DateTime.now().millisecondsSinceEpoch.toString());
      // await ref.putFile(File(image.path));
      // String url = await ref.getDownloadURL();
      // CloudMessage message = CloudMessage(
      //     from: myUid!,
      //     to: friendUid!,
      //     timeStamp: DateTime.now(),
      //     message: '',
      //     image: url);
      // fService.sendMessage(message, convoId!);
    }
  }
}
