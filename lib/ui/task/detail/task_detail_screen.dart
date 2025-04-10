import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mytask/data/repositories/task_repository.dart';
import 'package:mytask/di/app_dependencies.dart';
import 'package:mytask/ui/task/detail/bloc/task_detail_bloc.dart';
import 'package:mytask/ui/task/form/task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;
  final TaskRepository taskRepository;

  const TaskDetailScreen(
      {super.key, required this.taskId, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskDetailBloc(taskRepository: taskRepository)
        ..add(TaskDetailFetched(taskId)),
      child: _TaskDetailView(),
    );
  }
}

class _TaskDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskDetailBloc, TaskDetailState>(
      listener: (context, state) {
        if (state.isDeletionSuccessful == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task deleted successfully')),
          );
          Navigator.pop(context);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        switch (state.status) {
          case TaskDetailStatus.loading:
            return const Scaffold(
              appBar: _DetailAppBar(title: 'Detail Task'),
              body: Center(child: CircularProgressIndicator()),
            );
          case TaskDetailStatus.failure:
            return Scaffold(
              appBar: const _DetailAppBar(title: 'Detail Task'),
              body: Center(
                  child: Text(
                      'Failed to load task detail: ${state.errorMessage}')),
            );
          case TaskDetailStatus.success:
            final task = state.task!;
            return Scaffold(
              appBar: _DetailAppBar(title: 'Detail Task', taskId: task.id),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title ?? 'No Title',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          task.description ?? 'No Description',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _DetailBottomBar(),
                  ],
                ),
              ),
            );
          default:
            return const Scaffold(
              appBar: _DetailAppBar(title: 'Detail Task'),
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}

class _DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? taskId;

  const _DetailAppBar({required this.title, this.taskId});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: taskId != null
          ? [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (newContext) => BlocProvider.value(
                        value: BlocProvider.of<TaskDetailBloc>(context),
                        child: TaskFormScreen(
                          initialTask:
                              context.read<TaskDetailBloc>().state.task,
                          taskRepository: AppDependencies.getTaskRepository(),
                        ),
                      ),
                    ),
                  );

                  if (result != null && result == true) {
                    context
                        .read<TaskDetailBloc>()
                        .add(TaskDetailFetched(taskId ?? ""));
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<TaskDetailBloc>().add(TaskDetailDeleted());
                },
              ),
            ]
          : null,
    );
  }
}

class _DetailBottomBar extends StatelessWidget {
  const _DetailBottomBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskDetailBloc, TaskDetailState>(
      builder: (context, state) {
        final task = state.task;
        if (task == null) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.dueDate != null
                    ? 'Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}'
                    : 'No Due Date',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    'Completed',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    value: task.status?.toLowerCase() == 'completed',
                    onChanged: (bool? value) {
                      if (value != null) {
                        context
                            .read<TaskDetailBloc>()
                            .add(TaskDetailStatusChanged(value));
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
