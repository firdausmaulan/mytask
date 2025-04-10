part of 'task_list_bloc.dart';

abstract class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object> get props => [];
}

class TaskListFetched extends TaskListEvent {}

class TaskListReFetched extends TaskListEvent {}

class TaskListSearchChanged extends TaskListEvent {
  final String searchTerm;

  const TaskListSearchChanged(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}

class TaskListFilterChanged extends TaskListEvent {
  final List<String> statuses;

  const TaskListFilterChanged(this.statuses);

  @override
  List<Object> get props => [statuses];
}

class TaskListLoadMore extends TaskListEvent {}