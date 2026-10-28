import 'package:flutter/material.dart';
import 'package:smart_greenhouse/ui/theme/app_theme.dart';

/// Сітка, що підбирає кількість колонок під ширину екрана.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    super.key,
    this.minItemWidth = 160,
    this.itemHeight = 150,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double itemHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = (constraints.maxWidth / minItemWidth).floor().clamp(
          1,
          4,
        );
        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio:
              (constraints.maxWidth - AppSpacing.md * (columns - 1)) /
              columns /
              itemHeight,
          children: children,
        );
      },
    );
  }
}
