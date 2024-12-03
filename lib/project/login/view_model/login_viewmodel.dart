import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/api_service/user_service.dart';

class LoginViewModel with ChangeNotifier {
  final _userService = UserService();
  String? errorMessage;

  Future<bool> signIn(String email, String password) async {
    print('sign in $email');
    errorMessage = '';
    try {
      await _userService.login(email: email, password: password);
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
