import 'package:chat_app/app/app.router.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/locator.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends BaseViewModel {
  final authService = locator<AuthService>();
  final navigator = locator<NavigationService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  register() async {
    if (isBusy == false) {
      setBusy(true);
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        await authService.signUpUser(
            emailController.text, passwordController.text);

        navigator.clearStackAndShow(Routes.homeView);
      } catch (e) {
        null;
      }
      setBusy(false);
    }
  }

  onDispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  navigateToLoginView() {
    navigator.clearStackAndShow(Routes.loginView);
  }
}
