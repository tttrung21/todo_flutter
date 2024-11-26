import 'package:flutter/material.dart';
import 'package:todo_app/api_service/todo_service.dart';
import 'package:todo_app/model/todo_model.dart';


class TodoProvider with ChangeNotifier {
  List<TodoModel> _todos = [];
  bool _isLoading = false;
  final todoService = TodoService();
  String errorMessage = '';

  List<TodoModel> get todos => _todos;

  List<TodoModel> get completedList => _todos.where((element) => element.isCompleted).toList();

  List<TodoModel> get todoList => _todos.where((element) => !element.isCompleted).toList();

  bool get isLoading => _isLoading;

  TodoModel getTodo(int? id) {
    return _todos.firstWhere((element) => element.id == id);
  }

  Future<void> fetchTodos() async {
    _isLoading = true;
    errorMessage = '';
    notifyListeners();
    try {
      final response = await todoService.fetchTodos();
      if (response.isNotEmpty) {
        _todos = TodoModel.fromJsonToList(response);
        _todos.sort((a, b) {
          return a.id!.compareTo(b.id!);
        },);
      }
    } catch (e) {
      errorMessage = e.toString();
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTodo(TodoModel todo) async {
    errorMessage = '';
    try {
      await todoService.createTodo(todo);
      _todos.add(todo);
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<void> toggleComplete(int? id) async {
    errorMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      ///update on supabase
      final todo = getTodo(id);
      await todoService.toggleComplete(id!, !todo.isCompleted);

      ///update on local
      final todoIndex = _todos.indexWhere((todo) => todo.id == id);
      if (todoIndex == -1) return;
      final updatedTodo = _todos[todoIndex].copyWith(
        isCompleted: !_todos[todoIndex].isCompleted,
      );
      _todos[todoIndex] = updatedTodo;
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> updateTodo(TodoModel item) async {
    errorMessage = '';
    try {
      ///update on supabase
      await todoService.updateTodo(item);

      ///update on local
      final todoIndex = _todos.indexWhere((todo) => todo.id == item.id);
      if (todoIndex == -1) return false;
      _todos[todoIndex] = item;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
  Future<bool> deleteTodo(int? id) async {
    errorMessage = '';
    _isLoading = true;
    notifyListeners();
    try {
      ///delete on supabase
      await todoService.deleteTodo(id!);

      ///delete on local
      _todos.removeWhere((element) => element.id == id);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
