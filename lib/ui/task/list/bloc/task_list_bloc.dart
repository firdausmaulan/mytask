import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytask/data/models/task.dart';
import 'package:mytask/data/repositories/task_repository.dart';

part 'task_list_event.dart';
part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TaskRepository _taskRepository;
  int _page = 1;
  final int _limit = 10;

  TaskListBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskListState()) {
    on<TaskListFetched>(_onTaskListFetched);
    on<TaskListReFetched>(_onTaskListReFetched);
    on<TaskListSearchChanged>(_onTaskListSearchChanged);
    on<TaskListFilterChanged>(_onTaskListFilterChanged);
    on<TaskListLoadMore>(_onTaskListLoadMore);
  }

  Future<void> _onTaskListFetched(
      TaskListEvent event, Emitter<TaskListState> emit) async {
    if (state.status == TaskListStatus.success && state.hasReachedMax) return;
    emit(state.copyWith(
        status: state.tasks.isEmpty
            ? TaskListStatus.loading
            : TaskListStatus.success));
    try {
      final tasks = await _taskRepository.getTasks(
        page: _page,
        search: state.searchTerm.isNotEmpty ? state.searchTerm : null,
        status: state.selectedFilters.isNotEmpty
            ? state.selectedFilters.join(',')
            : null,
      );
      if (tasks.isEmpty) {
        emit(state.copyWith(
            hasReachedMax: true,
            status: state.tasks.isEmpty
                ? TaskListStatus.empty
                : TaskListStatus.success));
      } else {
        emit(
          state.copyWith(
            status: TaskListStatus.success,
            tasks: List.of(state.tasks)..addAll(tasks),
            hasReachedMax: tasks.length < _limit,
          ),
        );
        _page++;
      }
    } catch (e) {
      emit(state.copyWith(
          status: TaskListStatus.failure,
          errorMessage: 'Failed to fetch tasks'));
    }
  }

  void _onTaskListReFetched(
      TaskListReFetched event, Emitter<TaskListState> emit) {
    emit(state.copyWith(
        tasks: [],
        hasReachedMax: false,
        status: TaskListStatus.loading));
    _page = 1;
    add(TaskListFetched());
  }

  void _onTaskListSearchChanged(
      TaskListSearchChanged event, Emitter<TaskListState> emit) {
    emit(state.copyWith(
        searchTerm: event.searchTerm,
        tasks: [],
        hasReachedMax: false,
        status: TaskListStatus.loading));
    _page = 1;
    add(TaskListFetched());
  }

  void _onTaskListFilterChanged(
      TaskListFilterChanged event, Emitter<TaskListState> emit) {
    emit(state.copyWith(
        selectedFilters: event.statuses,
        tasks: [],
        hasReachedMax: false,
        status: TaskListStatus.loading));
    _page = 1;
    add(TaskListFetched());
  }

  Future<void> _onTaskListLoadMore(
      TaskListLoadMore event, Emitter<TaskListState> emit) async {
    if (!state.hasReachedMax && state.status != TaskListStatus.loading) {
      add(TaskListFetched());
    }
  }
}
