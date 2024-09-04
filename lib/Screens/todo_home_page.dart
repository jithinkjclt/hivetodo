import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hivelerning/Screens/cuubit_cubit.dart';
import 'package:hivelerning/components/custome_date_picker.dart';
import '../models/todo_model.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CuubitCubit(),
      child: BlocBuilder<CuubitCubit, CuubitState>(
        builder: (context, state) {
          final cubit = context.read<CuubitCubit>();
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                _showAddDialog(context, cubit);
              },
            ),
            appBar: AppBar(
              title: const Text("All Tasks"),
            ),
            body: cubit.todo.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(20),
                    height: double.infinity,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: cubit.todo.length,
                      itemBuilder: (context, index) {
                        final todo = cubit.todo[index];
                        return Card(
                          elevation: 5,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Image(
                                image: NetworkImage(todo.imgurl),
                                fit: BoxFit.fill,
                              ),
                            ),
                            tileColor: Colors.pink.shade50,
                            contentPadding: const EdgeInsets.all(15),
                            onTap: () {
                              _showEditDialog(context, cubit, todo, index);
                            },
                            trailing: SizedBox(
                              width: 70,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: todo.completed,
                                    onChanged: (value) {
                                      todo.completed = value!;
                                      cubit.todoService.updateTodo(index, todo);
                                      cubit.loadTodo();
                                    },
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cubit.todoService.deleteTodo(index);
                                      cubit.loadTodo();
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            title: Text(todo.title),
                            subtitle: Text(todo.createdAt.toString()),
                          ),
                        );
                      },
                    ),
                  )
                : const Center(child: Text("No Todo Added")),
          );
        },
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, CuubitCubit cubit) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 350,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  TextField(
                    decoration: const InputDecoration(hintText: "Title"),
                    controller: cubit.titlectr,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Description"),
                    controller: cubit.discriptionectr,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Image URL"),
                    controller: cubit.imgectr,
                  ),
                  SizedBox(
                    child: DateTimePicker(
                      onDateTimeSelected: (DateTime) {
                        cubit.dateTime = DateTime;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newTodo = Todo(
                  imgurl: cubit.imgectr.text,
                  title: cubit.titlectr.text,
                  completed: false,
                  createdAt: cubit.dateTime,
                  discription: cubit.discriptionectr.text,
                );
                await cubit.todoService.addTodo(newTodo);
                cubit.titlectr.clear();
                cubit.discriptionectr.clear();
                cubit.imgectr.clear();
                Navigator.pop(context);
                cubit.loadTodo();
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(
      BuildContext context, CuubitCubit cubit, Todo todo, int index) async {
    cubit.titlectr.text = todo.title;
    cubit.discriptionectr.text = todo.discription;
    cubit.imgectr.text = todo.imgurl;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 350,
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  TextField(
                    decoration: const InputDecoration(hintText: "Title"),
                    controller: cubit.titlectr,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Description"),
                    controller: cubit.discriptionectr,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: "Image URL"),
                    controller: cubit.imgectr,
                  ),
                  SizedBox(
                    child: DateTimePicker(
                      onDateTimeSelected: (DateTime) {
                        cubit.dateTime = DateTime;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                todo.title = cubit.titlectr.text;
                todo.discription = cubit.discriptionectr.text;
                todo.imgurl = cubit.imgectr.text;
                todo.createdAt = cubit.dateTime;
                await cubit.todoService.updateTodo(index, todo);
                cubit.titlectr.clear();
                cubit.discriptionectr.clear();
                cubit.imgectr.clear();
                Navigator.pop(context);
                cubit.loadTodo();
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}
