part of 'task_detail_bloc.dart';

enum TaskDetailStatus { initial, loading, success, failure }

class TaskDetailState extends Equatable {
  final TaskDetailStatus status;
  final Task? task;
  final String? errorMessage;
  final bool? isDeletionSuccessful;

  const TaskDetailState({
    this.status = TaskDetailStatus.initial,
    this.task,
    this.errorMessage,
    this.isDeletionSuccessful,
  });

  TaskDetailState copyWith({
    TaskDetailStatus? status,
    Task? task,
    String? errorMessage,
    bool? isDeletionSuccessful,
  }) {
    return TaskDetailState(
      status: status ?? this.status,
      task: task ?? this.task,
      errorMessage: errorMessage ?? this.errorMessage,
      isDeletionSuccessful: isDeletionSuccessful ?? this.isDeletionSuccessful,
    );
  }

  @override
  List<Object?> get props => [status, task, errorMessage, isDeletionSuccessful];
}