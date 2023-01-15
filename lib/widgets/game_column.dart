import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:flutter/material.dart';

import 'cell.dart';

class GameColumnWidget extends StatelessWidget {
  const GameColumnWidget({
    super.key,
    required this.rowWithQueen,
    required this.column,
    this.ghostQueenRow,
  });
  final int rowWithQueen;
  final int column;
  final int? ghostQueenRow;

  @override
  Widget build(BuildContext context) {
    return AnimatedGameColumnWidget(
      queenRow: rowWithQueen,
      column: column,
      ghostQueenRow: ghostQueenRow,
    );
    return BaseGameColumn(column: column);
  }
}

class BaseGameColumn extends StatelessWidget {
  const BaseGameColumn({
    super.key,
    required this.column,
  });

  final int column;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 8; row >= 1; row--)
          Expanded(
            child: GameCell(
              column: column,
              row: row,
              builder: (ctx, isWhiteSquare) => const SizedBox.expand(),
            ),
          ),
      ],
    );
  }
}

// animate the above widget. slide to new position
class AnimatedGameColumnWidget extends StatefulWidget {
  const AnimatedGameColumnWidget({
    super.key,
    required this.queenRow,
    this.ghostQueenRow,
    required this.column,
  });
  final int? ghostQueenRow;
  final int queenRow;
  final int column;

  @override
  _AnimatedGameColumnWidgetState createState() =>
      _AnimatedGameColumnWidgetState();
}

// should animate the queen sliding to the new position
class _AnimatedGameColumnWidgetState extends State<AnimatedGameColumnWidget>
    with SingleTickerProviderStateMixin {
  int get currentQueenRow => widget.queenRow;
  late int previousQueenRow;
  late AnimationController controller;
  late Animation<double> animation;
  bool get didQueenMove => previousQueenRow != currentQueenRow;
  bool get isQueenMovingUp => previousQueenRow > currentQueenRow;
  bool get isQueenMovingDown => previousQueenRow < currentQueenRow;

  late GlobalKey queenKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    previousQueenRow = widget.queenRow;
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  bool get queenWrappedBoard =>
      (previousQueenRow == 1 && currentQueenRow == 8) ||
      (previousQueenRow == 8 && currentQueenRow == 1);

  @override
  void didUpdateWidget(covariant AnimatedGameColumnWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.queenRow != widget.queenRow) {
      previousQueenRow = oldWidget.queenRow;
      if (queenWrappedBoard) {
        controller.reset();
        queenKey = GlobalKey();
      } else if (isQueenMovingUp) {
        controller.reverse();
      } else if (isQueenMovingDown) {
        controller.forward();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Curve curve = Curves.fastLinearToSlowEaseIn;
    if (queenWrappedBoard) {
      // curve = const TeleportCurve();
    }
    return AnimatedBuilder(
      animation: animation,
      child: SizedBox.expand(
        child: BaseGameColumn(
          column: widget.column,
        ),
      ),
      builder: (ctx, child) => LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.passthrough,
            children: [
              child!,
              // if (didQueenMove)
              AnimatedPositioned(
                key: queenKey,
                curve: curve,
                duration: controller.duration!,
                top: calculateTop(constraints),
                child: getCell(constraints),
              ),
              // if (widget.ghostQueenRow != null &&
              //     widget.ghostQueenRow != currentQueenRow)
              Positioned(
                top: calculateTop(
                  constraints,
                  row: widget.ghostQueenRow,
                ),
                child: getCell(constraints, opacity: .5, sizeMultiplier: 1.2),
              ),
            ],
          );
        },
      ),
    );
  }

  SizedBox getCell(BoxConstraints constraints,
      {double? opacity, double? sizeMultiplier}) {
    return SizedBox.fromSize(
      size: Size.square(constraints.maxHeight / 8),
      child: SizedBox.expand(
        child: GameCell(
          column: widget.column,
          row: null,
          builder: (ctx, isWhiteSquare) {
            return Opacity(
              opacity: opacity ?? 1,
              child: BlackQueen(
                size: calculateIconSize(constraints) * (sizeMultiplier ?? 1),
              ),
            );
          },
        ),
      ),
    );
  }

  double calculateTop(BoxConstraints constraints, {int? row}) {
    row ??= currentQueenRow;
    final cellHeight = constraints.maxHeight / 8;
    final queenHeight = cellHeight;
    final queenTop = (row - 1) * cellHeight;
    final queenBottom = queenTop + queenHeight;
    final top = queenBottom - queenHeight;
    return top;
  }

  double calculateIconSize(BoxConstraints constraints) {
    final cellHeight = constraints.maxHeight / 8;
    final queenHeight = cellHeight;
    return queenHeight;
  }
}
