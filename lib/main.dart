import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hivelerning/Screens/todo_home_page.dart';
import 'package:hivelerning/models/todo_model.dart';
import 'package:hivelerning/services/todo_service.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  await TodoService().openBox();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoScreen(),
    );
  }
}
