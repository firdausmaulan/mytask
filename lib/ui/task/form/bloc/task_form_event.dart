part of 'task_form_bloc.dart';

abstract class TaskFormEvent extends Equatable {
  const TaskFormEvent();

  @override
  List<Object?> get props => [];
}

class TaskFormTitleChanged extends TaskFormEvent {
  final String title;

  const TaskFormTitleChanged(this.title);

  @override
  List<Object?> get props => [title];
}

class TaskFormDescriptionChanged extends TaskFormEvent {
  final String description;

  const TaskFormDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class TaskFormDueDateChanged extends TaskFormEvent {
  final DateTime? dueDate;

  const TaskFormDueDateChanged(this.dueDate);

  @override
  List<Object?> get props => [dueDate];
}

class TaskFormStatusChanged extends TaskFormEvent {
  final String status;

  const TaskFormStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

class TaskFormSubmitted extends TaskFormEvent {}

class TaskFormLoaded extends TaskFormEvent {
  final Task? task;

  const TaskFormLoaded(this.task);

  @override
  List<Object?> get props => [task];
}