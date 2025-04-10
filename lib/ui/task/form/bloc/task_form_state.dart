part of 'task_form_bloc.dart';

enum TaskFormStatus { initial, loading, success, failure }

class TaskFormState extends Equatable {
  final TaskFormStatus status;
  final String title;
  final String description;
  final DateTime? dueDate;
  final String statusValue;
  final String? errorMessage;
  final bool isEditing;
  final Task? initialTask;
  final bool isSubmissionSuccessful;

  const TaskFormState({
    this.status = TaskFormStatus.initial,
    this.title = '',
    this.description = '',
    this.dueDate,
    this.statusValue = 'Incomplete',
    this.errorMessage,
    this.isEditing = false,
    this.initialTask,
    this.isSubmissionSuccessful = false,
  });

  TaskFormState copyWith({
    TaskFormStatus? status,
    String? title,
    String? description,
    DateTime? dueDate,
    String? statusValue,
    String? errorMessage,
    bool? isEditing,
    Task? initialTask,
    bool? isSubmissionSuccessful,
  }) {
    return TaskFormState(
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      statusValue: statusValue ?? this.statusValue,
      errorMessage: errorMessage ?? this.errorMessage,
      isEditing: isEditing ?? this.isEditing,
      initialTask: initialTask ?? this.initialTask,
      isSubmissionSuccessful: isSubmissionSuccessful ?? this.isSubmissionSuccessful,
    );
  }

  @override
  List<Object?> get props => [
    status,
    title,
    description,
    dueDate,
    statusValue,
    errorMessage,
    isEditing,
    initialTask,
    isSubmissionSuccessful,
  ];
}