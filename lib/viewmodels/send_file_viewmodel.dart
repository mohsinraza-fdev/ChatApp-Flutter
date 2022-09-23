import 'package:chat_app/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SendFileViewModel extends BaseViewModel {
  final navigator = locator<NavigationService>();

  send() {
    navigator.back(result: true);
  }
}
