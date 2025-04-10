import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mytask/ui/task/list/bloc/task_list_bloc.dart';

class TaskFilterBottomSheet extends StatefulWidget {
  const TaskFilterBottomSheet({super.key});

  @override
  State<TaskFilterBottomSheet> createState() => _TaskFilterBottomSheetState();
}

class _TaskFilterBottomSheetState extends State<TaskFilterBottomSheet> {
  late List<String> _selectedFilters;

  @override
  void initState() {
    super.initState();
    final taskListBloc = context.read<TaskListBloc>();
    _selectedFilters = List.from(taskListBloc.state.selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    final taskListBloc = context.read<TaskListBloc>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CheckboxListTile(
            title: const Text('Completed'),
            value: _selectedFilters.contains('Completed'),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  if (!_selectedFilters.contains('Completed')) {
                    _selectedFilters.add('Completed');
                  }
                } else {
                  _selectedFilters.remove('Completed');
                }
              });
            },
          ),
          CheckboxListTile(
            title: const Text('Incomplete'),
            value: _selectedFilters.contains('Incomplete'),
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  if (!_selectedFilters.contains('Incomplete')) {
                    _selectedFilters.add('Incomplete');
                  }
                } else {
                  _selectedFilters.remove('Incomplete');
                }
              });
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                taskListBloc.add(TaskListFilterChanged(_selectedFilters));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text('Confirm', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}