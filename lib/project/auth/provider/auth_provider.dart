import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/api_service/user_service.dart';
import 'package:todo_app/model/user_model.dart';

class AuthProvider with ChangeNotifier {
  final _userService = UserService();
  UserModel? _user;
  String? errorMessage;

  UserModel? get user => _user;

  Future<bool> signIn(String email, String password) async {
    errorMessage = '';
    try {
      await _userService.login(email: email, password: password);
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      print(e);
      errorMessage = e.toString();
      return false;
    }
  }
  Future<bool> signUp(String email, String password) async {
    errorMessage = '';
    try {
      await _userService.signup(email: email, password: password);
      await _userService.logout();
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      return false;
    } catch (e) {
      print(e);
      errorMessage = e.toString();
      return false;
    }
  }
  void logout() async{
    await _userService.logout();
  }
}
