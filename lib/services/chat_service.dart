import 'package:injectable/injectable.dart';

@lazySingleton
class ChatService {
  String? currentConversationId;
  String? currentConversationName;
}
