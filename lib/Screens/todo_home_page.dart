import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hivelerning/services/todo_service.dart';

import '../models/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _titlectr = TextEditingController();
  final TextEditingController _discriptionectr = TextEditingController();
  final TodoService _todoService = TodoService();
  List<Todo> _todo = [];

  Future<void> _loadTodo() async {
    _todo = await _todoService.getTodos();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddDilog();
        },
      ),
      appBar: AppBar(
        title: const Text("All Task"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemCount: _todo.length,
          itemBuilder: (context, index) {
            final todo = _todo[index];
            return Card(
              elevation: 5,
              child: ListTile(
                leading:  CircleAvatar(
                  child: Text("${index+1}"),
                ),
                tileColor: Colors.pink.shade50,
                contentPadding: const EdgeInsets.all(15),
                onTap: () {
                  _showEditDialog(todo, index);
                },
                trailing: Container(
                  width: 70,
                  child: Row(
                    children: [
                      Checkbox(
                        value: todo.completed,
                        onChanged: (value) {
                          setState(() {
                            todo.completed = value!;
                            _todoService.updateTodo(index, todo);
                            setState(() {});
                          });
                        },
                      ),
                      InkWell(
                        onTap: () {
                          _todoService.deleteTodo(index);
                          _loadTodo();
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
                subtitle: Text(todo.discription),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddDilog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Title"),
                  controller: _titlectr,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Discription"),
                  controller: _discriptionectr,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  final newTodo = Todo(
                      title: _titlectr.text,
                      completed: false,
                      createdAt: DateTime.now(),
                      discription: _discriptionectr.text);
                  await _todoService.addTodo(newTodo);
                  _titlectr.clear();
                  _discriptionectr.clear();
                  Navigator.pop(context);
                  _loadTodo();
                },
                child: const Text("Add"))
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(Todo todo, int index) async {
    _titlectr.text = todo.title;
    _discriptionectr.text = todo.discription;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Task"),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Title"),
                  controller: _titlectr,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: "Discription"),
                  controller: _discriptionectr,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
            ElevatedButton(
                onPressed: () async {
                  todo.title = _titlectr.text;
                  todo.discription = _discriptionectr.text;
                  todo.createdAt = DateTime.now();
                  if (todo.completed == false) {
                    todo.completed = true;
                  }
                  await _todoService.updateTodo(index, todo);
                  _titlectr.clear();
                  _discriptionectr.clear();
                  Navigator.pop(context);
                  _loadTodo();
                },
                child: const Text("Updated"))
          ],
        );
      },
    );
  }
}
