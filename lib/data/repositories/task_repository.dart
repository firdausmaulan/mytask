import 'package:mytask/data/models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks({int page = 1, String? search, String? status});
  Future<Task?> getTaskDetail(String id);
  Future<Task?> createTask(Task task);
  Future<Task?> updateTask(Task task);
  Future<bool> deleteTask(String id);
}