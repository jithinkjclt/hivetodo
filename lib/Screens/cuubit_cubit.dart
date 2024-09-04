import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

part 'cuubit_state.dart';

class CuubitCubit extends Cubit<CuubitState> {
  CuubitCubit() : super(CuubitInitial()) {
    loadTodo();
  }

  final TextEditingController titlectr = TextEditingController();
  final TextEditingController discriptionectr = TextEditingController();
  final TextEditingController imgectr = TextEditingController();
  final TodoService todoService = TodoService();

  dynamic dateTime;
  List<Todo> todo = [];

  Future<void> loadTodo() async {
    todo = await todoService.getTodos();
    initDelete();
    emit(CuubitInitial());
  }

  void initDelete() {
    for (int i = 0; i < todo.length; i++) {
      final todoItem = todo[i];

      if (todoItem.createdAt.isBefore(DateTime.now())) {
        todoService.deleteTodo(i);
        i--;
      }
    }
  }
}
