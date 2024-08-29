import 'dart:core';

import 'package:hive_flutter/adapters.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String discription;
  @HiveField(2)
  late DateTime createdAt;

  @HiveField(3)
  late bool completed;
  @HiveField(4)
  late String imgurl;

  Todo(
      {required this.title,
      required this.completed,
      required this.createdAt,
      required this.imgurl,
      required this.discription});
}
