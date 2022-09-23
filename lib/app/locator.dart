import 'package:chat_app/services/app_firebase_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/local_storage_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AppFirebaseService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => ChatService());
  locator.registerLazySingleton(() => LocalStorageService());
}
