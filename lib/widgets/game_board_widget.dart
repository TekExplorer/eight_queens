// ignore: unused_import
import 'dart:math';

import 'package:eight_queens/game/game_board.dart';
import 'package:flutter/material.dart';

import 'game_column.dart';

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
          // child: _Possibility1(minDimension: minDimension, gameBoard: gameBoard),
          child: Row(
            children: List.generate(8, (index) {
              final column = index + 1;
              return Expanded(
                child: GameColumnWidget(
                  rowWithQueen: gameBoard.queens
                      .firstWhere((q) => q.column == column)
                      .row,
                  column: column,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
