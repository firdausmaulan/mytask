import 'package:dio/dio.dart';
import 'package:mytask/data/models/task.dart';
import 'package:mytask/data/services/app_http_client.dart';

class TaskApiService {
  final AppHttpClient _httpClient;

  TaskApiService({required AppHttpClient httpClient}) : _httpClient = httpClient;

  Future<List<Task>> getTasks({int page = 1, String? search, String? status}) async {
    try {
      final Response response = await _httpClient.get('?path=tasks', params: {
        'page': page.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        final List<dynamic> items = data['data'] as List<dynamic>;
        return items.map((item) => Task.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task?> getTaskDetail(String id) async {
    try {
      final Response response = await _httpClient.get('?path=tasks/$id');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data as Map<String, dynamic>;
        return Task.fromJson(data['data'] as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null; // Task not found
      } else {
        throw Exception('Failed to load task detail: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task?> createTask(Task task) async {
    try {
      final Response response = await _httpClient.post('?path=tasks', body: {
        'title': task.title,
        'description': task.description,
        'due_date': task.dueDate?.toIso8601String().split('T')[0], // Format date for API
        'status': task.status,
      });

      if (response.statusCode == 201) {
        return Task.fromJson(response.data['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Failed to create task: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Task?> updateTask(Task task) async {
    try {
      final Response response = await _httpClient.put('?path=tasks/${task.id}', body: {
        'title': task.title,
        'description': task.description,
        'due_date': task.dueDate?.toIso8601String().split('T')[0], // Format date for API
        'status': task.status,
      });

      if (response.statusCode == 200) {
        return Task.fromJson(response.data['data'] as Map<String, dynamic>);
      } else if (response.statusCode == 404) {
        return null; // Task not found
      } else {
        throw Exception('Failed to update task: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      final Response response = await _httpClient.delete('?path=tasks/$id');
      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        return false; // Task not found
      } else {
        throw Exception('Failed to delete task: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      rethrow;
    }
  }
}