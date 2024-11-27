import 'package:flutter/material.dart';
import 'package:todo_app/api_service/todo_service.dart';
import 'package:todo_app/api_service/user_service.dart';
import 'package:todo_app/model/todo_model.dart';

class HomeViewModel with ChangeNotifier {
  List<TodoModel> _todos = [];
  bool _isLoading = false;
  final _todoService = TodoService();
  final _userService = UserService();
  String errorMessage = '';

  List<TodoModel> get todos => _todos;

  List<TodoModel> get completedList => _todos.where((element) => element.isCompleted).toList();

  List<TodoModel> get todoList => _todos.where((element) => !element.isCompleted).toList();

  bool get isLoading => _isLoading;

  TodoModel getTodo(int? id) {
    return _todos.firstWhere((element) => element.id == id);
  }

  Future<void> fetchTodos() async {
    errorMessage = '';
    _setLoadingTrue();
    try {
      final response = await _todoService.fetchTodos();
      if (response.isNotEmpty) {
        _todos = TodoModel.fromJsonToList(response);
        _todos.sort(
          (a, b) {
            return a.id!.compareTo(b.id!);
          },
        );
      }
    } catch (e) {
      errorMessage = e.toString();
      throw Exception(e);
    } finally {
      _setLoadingFalse();
    }
  }

  void addTodo(TodoModel todo) {
    errorMessage = '';
    _setLoadingTrue();
    try {
      ///update on local
      _todos.add(todo);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoadingFalse();
    }
  }

  void updateTodo(TodoModel item) {
    errorMessage = '';
    _setLoadingTrue();
    try {
      ///update on local
      final todoIndex = _todos.indexWhere((todo) => todo.id == item.id);
      if (todoIndex == -1) return;
      _todos[todoIndex] = item;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
    }finally{
      _setLoadingFalse();
    }
  }

  Future<void> toggleComplete(int? id) async {
    errorMessage = '';
    _setLoadingTrue();
    try {
      ///update on supabase
      final todo = getTodo(id);
      await _todoService.toggleComplete(id!, !todo.isCompleted);

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
      _setLoadingFalse();
    }
  }

  Future<bool> deleteTodo(int? id) async {
    errorMessage = '';
    _setLoadingTrue();
    try {
      ///delete on supabase
      await _todoService.deleteTodo(id!);

      ///delete on local
      _todos.removeWhere((element) => element.id == id);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      print(errorMessage);
      return false;
    } finally {
      _setLoadingFalse();
    }
  }

  void logout() async {
    await _userService.logout();
  }

  void _setLoadingTrue() {
    _isLoading = true;
    notifyListeners();
  }

  void _setLoadingFalse() {
    _isLoading = false;
    notifyListeners();
  }
}
