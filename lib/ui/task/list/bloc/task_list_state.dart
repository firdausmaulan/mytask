part of 'task_list_bloc.dart';

enum TaskListStatus { initial, loading, success, failure, empty }

class TaskListState extends Equatable {
  final TaskListStatus status;
  final List<Task> tasks;
  final bool hasReachedMax;
  final String? errorMessage;
  final String searchTerm;
  final List<String> selectedFilters;

  const TaskListState({
    this.status = TaskListStatus.initial,
    this.tasks = const [],
    this.hasReachedMax = false,
    this.errorMessage,
    this.searchTerm = '',
    this.selectedFilters = const [],
  });

  TaskListState copyWith({
    TaskListStatus? status,
    List<Task>? tasks,
    bool? hasReachedMax,
    String? errorMessage,
    String? searchTerm,
    List<String>? selectedFilters,
  }) {
    return TaskListState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage ?? this.errorMessage,
      searchTerm: searchTerm ?? this.searchTerm,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }

  @override
  List<Object?> get props => [status, tasks, hasReachedMax, errorMessage, searchTerm, selectedFilters];
}