import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mytask/data/models/task.dart';
import 'package:mytask/data/repositories/task_repository.dart';
import 'package:mytask/ui/task/form/bloc/task_form_bloc.dart';

class TaskFormScreen extends StatelessWidget {
  final Task? initialTask;
  final TaskRepository taskRepository;

  const TaskFormScreen({super.key, this.initialTask, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskFormBloc(taskRepository: taskRepository)
        ..add(TaskFormLoaded(initialTask)),
      child: _TaskFormView(),
    );
  }
}

class _TaskFormView extends StatefulWidget {
  @override
  State<_TaskFormView> createState() => _TaskFormViewState();
}

class _TaskFormViewState extends State<_TaskFormView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: context.read<TaskFormBloc>().state.dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      context.read<TaskFormBloc>().add(TaskFormDueDateChanged(picked));
    }
  }

  void _showStatusBottomSheet(BuildContext context) {
    showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext bc) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Incomplete'),
              onTap: () => Navigator.pop(context, 'Incomplete'),
            ),
            ListTile(
              title: const Text('Completed'),
              onTap: () => Navigator.pop(context, 'Completed'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null) {
        context.read<TaskFormBloc>().add(TaskFormStatusChanged(value));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskFormBloc, TaskFormState>(
      listener: (context, state) {
        if (state.isSubmissionSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${state.isEditing ? 'Task updated' : 'Task created'} successfully')),
          );
          Navigator.pop(context, true);
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.errorMessage}')),
          );
        }
        if (state.isEditing) {
          if (_titleController.text != state.title) {
            _titleController.text = state.title;
          }
          if (_descriptionController.text != state.description) {
            _descriptionController.text = state.description;
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.isEditing ? 'Edit Task' : 'Create Task'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => context.read<TaskFormBloc>().add(TaskFormTitleChanged(value)),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => context.read<TaskFormBloc>().add(TaskFormDescriptionChanged(value)),
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _selectDueDate(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(state.dueDate != null ? DateFormat('yyyy-MM-dd').format(state.dueDate!) : 'Select Due Date'),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _showStatusBottomSheet(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(state.statusValue),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: state.status == TaskFormStatus.loading ? null : () {
                    context.read<TaskFormBloc>().add(TaskFormSubmitted());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: state.status == TaskFormStatus.loading
                      ? const CircularProgressIndicator()
                      : const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}