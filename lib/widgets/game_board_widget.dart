// ignore: unused_import
import 'dart:math';

import 'package:eight_queens/game/game_board.dart';
import 'package:eight_queens/game/queen.dart';
import 'package:flutter/material.dart';
import 'package:local_hero/local_hero.dart';

class GameBoardWidget extends StatelessWidget {
  const GameBoardWidget({super.key, required this.gameBoard});
  final GameBoard gameBoard;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // figure out the maximum dimension in either direction and fill to fit as much as we can
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;
        final minDimension = min(width, height) / 8;
        return ConstrainedBox(
          constraints: BoxConstraints.tightFor(
            width: minDimension * 8,
            height: minDimension * 8,
          ),
          child: Stack(
            children: [
              for (var row = 8; row >= 1; row--)
                for (var column = 1; column <= 8; column++)
                  Positioned(
                    left: (column - 1) * minDimension,
                    top: (row - 1) * minDimension,
                    child: SizedBox.square(
                      dimension: minDimension,
                      child: SizedBox.expand(
                        child: Builder(
                          builder: (context) {
                            final isQueen = gameBoard.isQueen(
                              column: column,
                              row: row,
                            );
                            Widget? child;
                            if (isQueen) {
                              var queen = gameBoard.queens.firstWhere(
                                (q) => q.column == column,
                              );
                              child = LocalHero(
                                key: PageStorageKey<Queen>(queen),
                                tag: 'Queen at ${queen.column}',
                                child: const QueenWidget(),
                              );
                              // TODO: annoying assertion
                              child = const QueenWidget();
                            }
                            return GameCell(
                              column: column,
                              row: row,
                              child: child,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class GameCell extends StatelessWidget {
  const GameCell({
    super.key,
    required this.column,
    required this.row,
    this.child,
  });

  final int row;
  final int column;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: getColor(),
      child: Center(
        child: child,
      ),
    );
  }

  bool get isWhiteSquare => (row + column) % 2 == 0;
  Color getColor() => isWhiteSquare ? Colors.white : Colors.lightBlue;
}

class QueenWidget extends StatelessWidget {
  const QueenWidget({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.person,
      color: Colors.black,
    );
    // return CustomPaint(
    //   size: child == null ? const Size.square(50) : Size.zero,
    //   painter: const QueenPainter(),
    //   child: child,
    // );
  }
}

// a drawn chess queen - visible on both black and white squares
class QueenPainter extends CustomPainter {
  const QueenPainter({
    this.color = Colors.black,
    this.isOutline = false,
  });
  final Color color;
  final bool isOutline;
  // filled in

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = isOutline ? PaintingStyle.stroke : PaintingStyle.fill;

    // draw chess queen crown with the 5 stalks.

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10, paint);
  }

  @override
  bool shouldRepaint(QueenPainter oldDelegate) => false;
}
