import 'package:flutter/material.dart';

import '../../utils/custom_colors.dart';

class TaskSearch extends StatelessWidget {
  const TaskSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CustomColors>();
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: colors?.surface, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search_rounded, size: 32, color: colors?.icon),
          hintText: 'Search a task...',
          hintStyle: Theme.of(context).textTheme.titleMedium,
        ),
        maxLines: 1,
      ),
    );
  }
}
