part of 'task_detail_bloc.dart';

abstract class TaskDetailEvent extends Equatable {
  const TaskDetailEvent();

  @override
  List<Object> get props => [];
}

class TaskDetailFetched extends TaskDetailEvent {
  final String taskId;

  const TaskDetailFetched(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class TaskDetailStatusChanged extends TaskDetailEvent {
  final bool isCompleted;

  const TaskDetailStatusChanged(this.isCompleted);

  @override
  List<Object> get props => [isCompleted];
}

class TaskDetailDeleted extends TaskDetailEvent {}