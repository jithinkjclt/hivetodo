import 'package:hive_flutter/adapters.dart';

import '../models/todo_model.dart';

class TodoService {
  Box<Todo>? _todoBox;

  Future<void> openBox() async {
    _todoBox = await Hive.openBox<Todo>("todos");
  }

  Future<void> closebox() async {
    await _todoBox!.close();
  }

//   add todo
  Future<void> addTodo(Todo todo) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.add(todo);
  }

  // get all todo

  Future<List<Todo>> getTodos() async {
    if (_todoBox == null) {
      await openBox();
    }
    return _todoBox!.values.toList();
  }

  // update  todo

  Future<void> updateTodo(int index, Todo todo) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.putAt(index, todo);
  }

//delete todo

  Future<void> deleteTodo(int index) async {
    if (_todoBox == null) {
      await openBox();
    }
    await _todoBox!.deleteAt(index);
  }
}
