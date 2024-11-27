import 'package:flutter/material.dart';
import 'package:todo_app/api_service/todo_service.dart';
import 'package:todo_app/model/todo_model.dart';


class NewTaskViewModel with ChangeNotifier {
  final _todoService = TodoService();
  String errorMessage = '';


  Future<TodoModel?> addTodo(TodoModel todo) async {
    errorMessage = '';
    try {
      final res = await _todoService.createTodo(todo);
      return TodoModel.fromJson(res);
    } catch (e) {
      errorMessage = e.toString();
      return null;
    }
  }
  Future<TodoModel?> updateTodo(TodoModel item) async {
    errorMessage = '';
    try {
      ///update on supabase
      final res = await _todoService.updateTodo(item);
      return TodoModel.fromJson(res);
    } catch (e) {
      errorMessage = e.toString();
      return null;
    }
  }
}
