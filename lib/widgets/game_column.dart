import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:eight_queens/providers/animation_speed.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/position.dart';
import 'tile.dart';

class GameColumn extends ConsumerWidget {
  const GameColumn({
    super.key,
    required this.column,
    required this.queen,
    required this.ghost,
  });

  final Position column;
  final Position queen;
  final Position? ghost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileSize = constraints.maxWidth;
        return Stack(
          children: [
            Column(
              children: [
                for (final Position row in Position.values)
                  SizedBox.square(
                    dimension: tileSize,
                    child: Tile(
                      column: column,
                      row: row,
                    ),
                  ),
              ],
            ),
            AnimatedPositioned(
              duration: ref.watch(animationDurationProvider),
              top: queen.index * tileSize,
              child: SizedBox.square(
                dimension: tileSize,
                child: BlackQueen(),
              ),
            ),
            if (ghost != null && ghost != queen)
              AnimatedPositioned(
                duration: ref.watch(animationDurationProvider),
                top: ghost!.index * tileSize,
                child: SizedBox.square(
                  dimension: tileSize,
                  child: const WalkerBlackQueen(),
                ),
              ),
            if (ghost != null && ghost != queen)
              // an arrow pointing from the queen to the ghost
              Positioned(
                height: tileSize * (ghost!.index - queen.index).abs(),
                width: tileSize,
                top: ghost!.index > queen.index
                    ? (queen.index * tileSize + tileSize / 2)
                    : (ghost!.index * tileSize + tileSize / 2),
                left: tileSize / 2,
                child: SizedBox.square(
                  dimension: tileSize,
                  child: Arrow(
                    length: (ghost!.index - queen.index).abs(),
                    cellSize: tileSize,
                    fillColor: Colors.green.withOpacity(.5),
                    direction: ghost!.index > queen.index
                        ? ArrowDirection.down
                        : ArrowDirection.up,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class Arrow extends StatelessWidget {
  const Arrow({
    super.key,
    required this.length,
    required this.cellSize,
    required this.direction,
    this.fillColor = Colors.black,
  });
  final double cellSize;
  final int length;
  final ArrowDirection direction;
  final Color fillColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ArrowPainter(
        length: length,
        cellSize: cellSize,
        direction: direction,
        fillColor: fillColor,
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  const ArrowPainter({
    required this.length,
    required this.cellSize,
    required this.direction,
    this.fillColor = Colors.black,
  });
  final double cellSize;
  // number of cells it goes over
  final int length;
  final ArrowDirection direction;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final Path path = Path();

    final double arrowWidth = cellSize / 2;
    final double arrowHeight = cellSize / 2;

    // draw a dot in the center
    // path.addOval(
    //   Rect.fromCenter(
    //     center: Offset(0, size.height / 2),
    //     width: cellSize / 4,
    //     height: cellSize / 4,
    //   ),
    // );

    final middle = Offset(0, size.height / 2);

    // move there first
    path.moveTo(0, size.height / 2);
    // draw the line with
    path.addRect(
      Rect.fromCenter(
        center: middle,
        height: (cellSize * (length - 1)),
        width: cellSize / 4,
      ),
    );
    // now the arrow based on direction

    switch (direction) {
      case ArrowDirection.up:
        path.moveTo(0, size.height);
        path.lineTo(-arrowWidth / 2, size.height - arrowHeight);
        path.lineTo(arrowWidth / 2, size.height - arrowHeight);
        path.lineTo(0, size.height);
        break;
      case ArrowDirection.down:
        path.moveTo(0, 0);
        path.lineTo(-arrowWidth / 2, arrowHeight);
        path.lineTo(arrowWidth / 2, arrowHeight);
        path.lineTo(0, 0);
        break;
    }

    final Path shiftedPath;
    switch (direction) {
      case ArrowDirection.up:
        shiftedPath = path.shift(Offset(0, -cellSize / 4));
        break;
      case ArrowDirection.down:
        shiftedPath = path.shift(Offset(0, cellSize / 4));
        break;
    }

    canvas.drawPath(shiftedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum ArrowDirection { up, down }

class WalkerBlackQueen extends StatelessWidget {
  const WalkerBlackQueen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlackQueen(
      fillColor: Theme.of(context).colorScheme.onPrimary,
      decorationColor: Theme.of(context).colorScheme.onSecondary,
      strokeColor: Theme.of(context).colorScheme.onSecondary,
    );
  }
}
