import 'package:chat_app/app/app.router.dart';
import 'package:chat_app/app/locator.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  final authService = locator<AuthService>();
  final navigator = locator<NavigationService>();

  checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 1));
    if (await authService.isUserLoggedIn()) {
      navigator.clearStackAndShow(Routes.homeView);
    } else {
      navigator.clearStackAndShow(Routes.loginView);
    }
  }
}
