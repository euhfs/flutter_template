import 'package:flutter/material.dart';

import '../components/task_search.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Spacer
        SizedBox(height: 16),

        // Task Search
        TaskSearch(),

        // Label
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text('Your Tasks', style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }
}
