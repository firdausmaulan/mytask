import 'package:mytask/data/repositories/task_repository.dart';
import 'package:mytask/data/repositories/task_repository_impl.dart';
import 'package:mytask/data/services/app_http_client.dart';
import 'package:mytask/data/services/task_api_service.dart';

class AppDependencies {
  static final AppHttpClient _appHttpClient = AppHttpClient();
  static final TaskApiService _taskApiService = TaskApiService(httpClient: _appHttpClient);
  static final TaskRepository _taskRepository = TaskRepositoryImpl(taskApiService: _taskApiService);

  static TaskRepository getTaskRepository() {
    return _taskRepository;
  }
}