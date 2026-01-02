import 'package:flutter/material.dart';

import '../../utils/custom_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<CustomColors>();
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Top
          SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: BoxDecoration(color: colors?.surface),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text('Tasks', style: Theme.of(context).textTheme.headlineMedium),

                  // Version
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text('v1.0.0', style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ),
          ),

          // Settings
          ListTile(),
        ],
      ),
    );
  }
}
