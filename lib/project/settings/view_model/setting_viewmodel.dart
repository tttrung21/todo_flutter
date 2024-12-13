import 'package:todo_app/api_service/user_service.dart';

class SettingViewModel {
  final _userService = UserService();

  void logout() async {
    await _userService.logout();
  }
}