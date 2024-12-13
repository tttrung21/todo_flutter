import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/api_service/user_service.dart';

class RegisterViewModel with ChangeNotifier {
  final _userService = UserService();
  String? errorMessage;

  Future<bool> signUp(String email, String password) async {
    errorMessage = '';
    try {
      await _userService.signup(email: email, password: password);
      await _userService.logout();
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}
