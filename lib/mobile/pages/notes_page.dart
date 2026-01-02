import 'package:flutter/material.dart';

import '../components/note_search.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Spacer
        SizedBox(height: 16),

        // Task Search
        NoteSearch(),

        // Label
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text('Your Notes', style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    );
  }
}
