import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mytask/data/models/task.dart';
import 'package:mytask/di/app_dependencies.dart';
import 'package:mytask/ui/task/detail/task_detail_screen.dart';
import 'package:mytask/ui/task/list/bloc/task_list_bloc.dart';

class TaskCardItem extends StatelessWidget {
  final Task task;

  const TaskCardItem({super.key, required this.task});

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'incomplete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result =  await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(
              taskId: task.id ?? "",
              taskRepository: AppDependencies.getTaskRepository(),
            ),
          ),
        );
        if (result == null) {
          context.read<TaskListBloc>().add(TaskListReFetched());
        } else {
          context.read<TaskListBloc>().add(TaskListReFetched());
        }
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title ?? 'No Title',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task.dueDate != null
                        ? 'Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}'
                        : 'No Due Date',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Text(
                    task.status ?? 'Unknown',
                    style: TextStyle(
                      color: _getStatusColor(task.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
