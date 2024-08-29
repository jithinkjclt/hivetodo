import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../models/todo_model.dart';
import '../services/todo_service.dart';

part 'cuubit_state.dart';

class CuubitCubit extends Cubit<CuubitState> {
  CuubitCubit() : super(CuubitInitial());

  final TextEditingController titlectr = TextEditingController();
  final TextEditingController discriptionectr = TextEditingController();
  final TextEditingController imgectr = TextEditingController();
  final TodoService todoService = TodoService();
  List<Todo> todo = [];

  Future<void> loadTodo() async {
    todo = await todoService.getTodos();
    emit(CuubitInitial());
  }
}
