import 'package:mytask/data/models/task.dart';
import 'package:mytask/data/repositories/task_repository.dart';
import 'package:mytask/data/services/task_api_service.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskApiService _taskApiService;

  TaskRepositoryImpl({required TaskApiService taskApiService}) : _taskApiService = taskApiService;

  @override
  Future<List<Task>> getTasks({int page = 1, String? search, String? status}) async {
    try {
      return await _taskApiService.getTasks(page: page, search: search, status: status);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Task?> getTaskDetail(String id) async {
    try {
      return await _taskApiService.getTaskDetail(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Task?> createTask(Task task) async {
    try {
      return await _taskApiService.createTask(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Task?> updateTask(Task task) async {
    try {
      return await _taskApiService.updateTask(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> deleteTask(String id) async {
    try {
      return await _taskApiService.deleteTask(id);
    } catch (e) {
      rethrow;
    }
  }
}