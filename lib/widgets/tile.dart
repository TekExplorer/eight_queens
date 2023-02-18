import 'package:eight_queens/providers/position.dart';
import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.column,
    required this.row,
  });

  final Position column;
  final Position row;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: isWhite(column, row)
          ? colorScheme.secondaryContainer
          : colorScheme.primaryContainer,
    );
  }

  static bool isWhite(Position column, Position row) {
    final bool columnIsEven = column.index % 2 == 0;
    final bool rowIsEven = row.index % 2 == 0;
    return columnIsEven != rowIsEven;
  }
}

extension CopyWithColor on Color {
  Color copyWithBrightness(double brightness) {
    return Color.fromARGB(
      alpha,
      (red * brightness).round(),
      (green * brightness).round(),
      (blue * brightness).round(),
    );
  }

  Color copyWithDarker(double factor) {
    return copyWithBrightness(1 - factor);
  }

  Color copyWithLighter(double factor) {
    return copyWithBrightness(1 + factor);
  }
}
