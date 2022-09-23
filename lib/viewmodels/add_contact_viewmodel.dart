import 'package:chat_app/app/locator.dart';
import 'package:chat_app/services/app_firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth_service.dart';

class AddContactViewModel extends BaseViewModel {
  final fService = locator<AppFirebaseService>();
  final authService = locator<AuthService>();
  final navigator = locator<NavigationService>();

  String? get myUid => authService.user?.uid;
  String? get myEmail => authService.user?.email;

  TextEditingController textController = TextEditingController();

  bool _isAddingUser = false;
  bool get isAddingUser => _isAddingUser;
  set isAddingUser(bool value) {
    _isAddingUser = value;
    notifyListeners();
  }

  addConversation() async {
    isAddingUser = true;
    try {
      await fService.addUser(myUid!, myEmail!, textController.text);
      navigator.back();
    } catch (e) {
      print(e.toString());
    }
    textController.clear();
    isAddingUser = false;
  }

  onDispose() {
    textController.dispose();
  }
}
