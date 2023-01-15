import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';

class GameCell extends StatelessWidget {
  const GameCell({
    super.key,
    required this.column,
    required this.row,
    this.builder,
  });

  final int? row;
  final int column;
  final Widget Function(BuildContext context, bool? isWhiteSquare)? builder;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColor(),
      child: Center(
        child: builder?.call(context, isWhiteSquare),
      ),
    );
  }

  bool? get isWhiteSquare {
    if (row == null) return null;
    return (row! + column) % 2 == 0;
  }

  Color getColor() {
    if (isWhiteSquare == null) return Colors.transparent;
    return isWhiteSquare! ? Colors.white : Colors.lightBlue;
  }
}

class QueenWidget extends StatelessWidget {
  const QueenWidget({super.key, this.accentColor});
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return BlackQueen(
      decorationColor: accentColor,
    );
  }
}
