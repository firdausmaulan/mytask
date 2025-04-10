import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytask/data/repositories/task_repository.dart';
import 'package:mytask/di/app_dependencies.dart';
import 'package:mytask/ui/commons/search_field.dart';
import 'package:mytask/ui/task/form/task_form_screen.dart';
import 'package:mytask/ui/task/list/bloc/task_list_bloc.dart';
import 'package:mytask/ui/task/list/widgets/task_card_item.dart';
import 'package:mytask/ui/task/list/widgets/task_filter_bottom_sheet.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key, required this.taskRepository});

  final TaskRepository taskRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      TaskListBloc(taskRepository: taskRepository)..add(TaskListFetched()),
      child: _TaskListScreenContent(),
    );
  }
}

class _TaskListScreenContent extends StatelessWidget {
  const _TaskListScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
      ),
      body: const Column(
        children: [
          TaskListTopSection(),
          Expanded(
            child: TaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormScreen(
                taskRepository: AppDependencies.getTaskRepository(),
              ),
            ),
          );
          if (result != null && result == true) {
            BlocProvider.of<TaskListBloc>(context).add(TaskListReFetched());
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskListTopSection extends StatelessWidget {
  const TaskListTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    final taskListBloc = BlocProvider.of<TaskListBloc>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SearchField(
              hintText: "Search tasks...",
              onSearch: (query) =>
                  taskListBloc.add(TaskListSearchChanged(query)),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return BlocProvider.value(
          value: BlocProvider.of<TaskListBloc>(context),
          child: const TaskFilterBottomSheet(),
        );
      },
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        switch (state.status) {
          case TaskListStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case TaskListStatus.failure:
            return Center(child: Text('Error: ${state.errorMessage}'));
          case TaskListStatus.empty:
            return const Center(child: Text('No tasks yet.'));
          case TaskListStatus.success:
            if (state.tasks.isEmpty && state.searchTerm.isNotEmpty) {
              return const Center(
                  child: Text('No tasks found matching your search.'));
            } else if (state.tasks.isEmpty &&
                state.selectedFilters.isNotEmpty) {
              return const Center(
                  child: Text('No tasks found with the selected filters.'));
            } else if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks available.'));
            }
            return ListView.builder(
              itemCount: state.hasReachedMax
                  ? state.tasks.length
                  : state.tasks.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index >= state.tasks.length) {
                  BlocProvider.of<TaskListBloc>(context).add(TaskListLoadMore());
                  return const Center(child: CircularProgressIndicator());
                }
                final task = state.tasks[index];
                return TaskCardItem(task: task);
              },
            );
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}