import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytask/data/models/task.dart';
import 'package:mytask/data/repositories/task_repository.dart';

part 'task_form_event.dart';
part 'task_form_state.dart';

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  final TaskRepository _taskRepository;

  TaskFormBloc({required TaskRepository taskRepository})
      : _taskRepository = taskRepository,
        super(const TaskFormState()) {
    on<TaskFormTitleChanged>(_onTitleChanged);
    on<TaskFormDescriptionChanged>(_onDescriptionChanged);
    on<TaskFormDueDateChanged>(_onDueDateChanged);
    on<TaskFormStatusChanged>(_onStatusChanged);
    on<TaskFormSubmitted>(_onSubmitted);
    on<TaskFormLoaded>(_onLoaded);
  }

  void _onTitleChanged(TaskFormTitleChanged event, Emitter<TaskFormState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(TaskFormDescriptionChanged event, Emitter<TaskFormState> emit) {
    emit(state.copyWith(description: event.description));
  }

  void _onDueDateChanged(TaskFormDueDateChanged event, Emitter<TaskFormState> emit) {
    emit(state.copyWith(dueDate: event.dueDate));
  }

  void _onStatusChanged(TaskFormStatusChanged event, Emitter<TaskFormState> emit) {
    emit(state.copyWith(statusValue: event.status));
  }

  Future<void> _onSubmitted(TaskFormSubmitted event, Emitter<TaskFormState> emit) async {
    emit(state.copyWith(status: TaskFormStatus.loading));
    try {
      final taskToSave = Task(
        id: state.isEditing ? state.initialTask?.id : null,
        title: state.title,
        description: state.description,
        dueDate: state.dueDate,
        status: state.statusValue,
      );

      Task? savedTask;
      if (state.isEditing) {
        savedTask = await _taskRepository.updateTask(taskToSave);
      } else {
        savedTask = await _taskRepository.createTask(taskToSave);
      }

      if (savedTask != null) {
        emit(state.copyWith(status: TaskFormStatus.success, isSubmissionSuccessful: true));
      } else {
        emit(state.copyWith(status: TaskFormStatus.failure, errorMessage: 'Failed to save task'));
      }
    } catch (e) {
      emit(state.copyWith(status: TaskFormStatus.failure, errorMessage: 'Failed to save task: $e'));
    }
  }

  void _onLoaded(TaskFormLoaded event, Emitter<TaskFormState> emit) {
    if (event.task != null) {
      emit(state.copyWith(
        isEditing: true,
        initialTask: event.task,
        title: event.task!.title ?? '',
        description: event.task!.description ?? '',
        dueDate: event.task!.dueDate,
        statusValue: event.task!.status ?? 'Incomplete',
      ));
    } else {
      emit(const TaskFormState(isEditing: false)); // Creating a new task
    }
  }
}