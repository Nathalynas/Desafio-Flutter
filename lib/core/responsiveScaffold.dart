// ignore_for_file: file_names

import 'package:almeidatec/core/colors.dart';
import 'package:flutter/material.dart';
import 'main_drawer.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final List<Widget>? actions;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 800;

    final header = Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.background, 
            ),
          ),
          if (actions != null) Row(children: actions!),
        ],
      ),
    );

    return Scaffold(
      appBar: isLargeScreen
          ? null
          : AppBar(
              title: Text(title),
              actions: actions,
              iconTheme: const IconThemeData(color: AppColors.background),
            ),
      drawer: isLargeScreen ? null : const MainDrawer(),
      body: Row(
        children: [
          if (isLargeScreen)
            const SizedBox(
              width: 240,
              child: MainDrawer(),
            ),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLargeScreen) header,
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
