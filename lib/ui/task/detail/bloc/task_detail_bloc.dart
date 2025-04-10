import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytask/data/models/task.dart';
import 'package:mytask/data/repositories/task_repository.dart';

part 'task_detail_event.dart';
part 'task_detail_state.dart';

class TaskDetailBloc extends Bloc<TaskDetailEvent, TaskDetailState> {
  final TaskRepository _taskRepository;

  TaskDetailBloc({required TaskRepository taskRepository}) : _taskRepository = taskRepository, super(const TaskDetailState()) {
    on<TaskDetailFetched>(_onTaskDetailFetched);
    on<TaskDetailStatusChanged>(_onTaskDetailStatusChanged);
    on<TaskDetailDeleted>(_onTaskDetailDeleted);
  }

  Future<void> _onTaskDetailFetched(TaskDetailFetched event, Emitter<TaskDetailState> emit) async {
    emit(state.copyWith(status: TaskDetailStatus.loading));
    try {
      final task = await _taskRepository.getTaskDetail(event.taskId);
      if (task != null) {
        emit(state.copyWith(status: TaskDetailStatus.success, task: task));
      } else {
        emit(state.copyWith(status: TaskDetailStatus.failure, errorMessage: 'Task not found'));
      }
    } catch (e) {
      emit(state.copyWith(status: TaskDetailStatus.failure, errorMessage: 'Failed to load task detail: $e'));
    }
  }

  Future<void> _onTaskDetailStatusChanged(TaskDetailStatusChanged event, Emitter<TaskDetailState> emit) async {
    if (state.task == null) return;
    final updatedTask = state.task!.copyWith(status: event.isCompleted ? 'Completed' : 'Incomplete');
    emit(state.copyWith(task: updatedTask)); // Optimistic update
    try {
      final updatedResult = await _taskRepository.updateTask(updatedTask);
      if (updatedResult != null) {
        emit(state.copyWith(task: updatedResult));
      } else {
        emit(state.copyWith(task: state.task, errorMessage: 'Failed to update task status'));
      }
    } catch (e) {
      emit(state.copyWith(task: state.task, errorMessage: 'Failed to update task status: $e'));
    }
  }

  Future<void> _onTaskDetailDeleted(TaskDetailDeleted event, Emitter<TaskDetailState> emit) async {
    if (state.task == null) return;
    emit(state.copyWith(status: TaskDetailStatus.loading));
    try {
      final isDeleted = await _taskRepository.deleteTask(state.task?.id ?? "");
      if (isDeleted) {
        emit(state.copyWith(status: TaskDetailStatus.success, isDeletionSuccessful: true));
      } else {
        emit(state.copyWith(status: TaskDetailStatus.failure, errorMessage: 'Failed to delete task'));
      }
    } catch (e) {
      emit(state.copyWith(status: TaskDetailStatus.failure, errorMessage: 'Failed to delete task: $e'));
    }
  }
}