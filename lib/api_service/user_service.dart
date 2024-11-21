import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final client = Supabase.instance.client;

  Future<void> login({required String email, required String password}) async {
    await client.auth.signInWithPassword(password: password, email: email);
  }

  Future<void> logout() async {
    await client.auth.signOut();
  }
  Future<void> signup({required String email, required String password}) async{
    await client.auth.signUp(password: password,email: email);
  }
}
