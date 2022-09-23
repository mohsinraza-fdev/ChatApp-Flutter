import 'package:chat_app/app/app.router.dart';
import 'package:chat_app/app/locator.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final authService = locator<AuthService>();
  final navigator = locator<NavigationService>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    if (isBusy == false) {
      setBusy(true);
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        await authService.signInUser(
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

  navigateToRegisterView() {
    navigator.clearStackAndShow(Routes.registerView);
  }
}
