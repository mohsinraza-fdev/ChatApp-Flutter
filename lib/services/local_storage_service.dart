import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message_model.dart';

@lazySingleton
class LocalStorageService {
  String fileRegistryKey = 'file_registry_key';
  String messageBufferKey = 'message_buffer_key';
  String downloadingFilesKey = 'downloading_fiels_key';

  late SharedPreferences pref;

  Future<void> addFileToRegistry(String key, String value) async {
    Map<String, dynamic> registry = <String, dynamic>{};
    String? localData = pref.getString(fileRegistryKey);
    if (localData != null) {
      Map<String, dynamic> json = jsonDecode(localData);
      registry = json;
    }
    registry[key] = value;
    await pref.setString(fileRegistryKey, jsonEncode(registry));
  }

  getFileRegistryData() {
    Map<String, dynamic> registry = <String, dynamic>{};
    String? localData = pref.getString(fileRegistryKey);
    if (localData != null) {
      registry = jsonDecode(localData);
    }
    return registry;
  }

  saveBufferMessages(List<CloudMessage> messages) async {
    List<Map<String, dynamic>> data = <Map<String, dynamic>>[];
    for (CloudMessage message in messages) {
      data.add(message.toJson());
    }
    await pref.setString(messageBufferKey, jsonEncode(data));
  }

  List<CloudMessage> loadBufferMessages() {
    List<CloudMessage> messages = <CloudMessage>[];
    String? localData = pref.getString(messageBufferKey);
    if (localData != null) {
      for (Map<String, dynamic> message in jsonDecode(localData)) {
        CloudMessage tempMessage = CloudMessage.fromJson(message);
        tempMessage.buffered = true;
        messages.add(tempMessage);
      }
    }
    return messages;
  }

  Future<void> addMessageToBuffer(CloudMessage message) async {
    List<CloudMessage> messages = loadBufferMessages();
    messages.add(message);
    await saveBufferMessages(messages);
  }

  clearBuffer() async {
    await saveBufferMessages(<CloudMessage>[]);
  }

  loadDownloadingFiles() {
    List<String>? list = pref.getStringList(downloadingFilesKey);
    if (list == null) {
      return <String>[];
    }
    return list;
  }

  saveDownloadingFiles(List<String> files) async {
    await pref.setStringList(downloadingFilesKey, files);
  }

  removeDownloadingFile(String messageId) async {
    List<String> list = loadDownloadingFiles();
    list.remove(messageId);
    await saveDownloadingFiles(list);
  }

  disableBackgroundTasks() async {
    await clearBuffer();
    await saveDownloadingFiles(<String>[]);
  }
}
