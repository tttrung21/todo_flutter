import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoService {
  final client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final res = await client.from('Todo').select().eq('user_id', client.auth.currentUser?.id ?? '');
    return res;
  }

  Future<Map<String, dynamic>> createTodo(TodoModel todo) async {
    final res = await client.from('Todo').insert(todo.toJson()).select();
    return res.first;
  }

  Future<void> toggleComplete(int id, bool isCompleted) async {
    await client
        .from('Todo')
        .update({'is_completed': isCompleted})
        .eq('id', id)
        .eq('user_id', client.auth.currentUser?.id ?? '');
  }

  Future<void> deleteTodo(int id) async {
    await client
        .from('Todo')
        .delete()
        .eq('id', id)
        .eq('user_id', client.auth.currentUser?.id ?? '');
  }
  Future<void> updateTodo(TodoModel todo) async {
    await client
        .from('Todo')
        .update(todo.toJsonUpdate())
        .eq('id', todo.id!)
        .eq('user_id', client.auth.currentUser?.id ?? '');
  }
}
