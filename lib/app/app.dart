import 'package:chat_app/views/chat/chat_view.dart';
import 'package:chat_app/views/home/home_view.dart';
import 'package:chat_app/views/login/login_view.dart';
import 'package:chat_app/views/register/register_view.dart';
import 'package:chat_app/views/splash/splash_view.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(routes: [
  MaterialRoute(page: SplashView, initial: true),
  MaterialRoute(page: LoginView),
  MaterialRoute(page: RegisterView),
  MaterialRoute(page: HomeView),
  MaterialRoute(page: ChatView),
])
class AppSetup {}
