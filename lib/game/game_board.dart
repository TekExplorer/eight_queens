// 8 queens problem

import 'package:eight_queens/game/queen.dart';
import 'package:flutter/foundation.dart';

import 'game_board_mixin.dart';

abstract class GameBoardBase {
  const GameBoardBase();
  Queen get queenAtColumn1;
  Queen get queenAtColumn2;
  Queen get queenAtColumn3;
  Queen get queenAtColumn4;
  Queen get queenAtColumn5;
  Queen get queenAtColumn6;
  Queen get queenAtColumn7;
  Queen get queenAtColumn8;
  List<Queen> get queens => [
        queenAtColumn1,
        queenAtColumn2,
        queenAtColumn3,
        queenAtColumn4,
        queenAtColumn5,
        queenAtColumn6,
        queenAtColumn7,
        queenAtColumn8,
      ];

  void reset() {
    for (var queen in queens) {
      queen.reset();
    }
  }

  /// The heuristic value of the board.
  int get heuristicValue {
    var value = 0;
    for (var queen in queens) {
      for (var otherQueen in queens) {
        if (queen == otherQueen) continue;
        if (queen.collidesWithQueen(otherQueen)) {
          value++;
        }
      }
    }
    return value ~/ 2;
  }

  bool get isSolved {
    for (var queen in queens) {
      if (queen.isUnset) throw QueenNotOnBoardError(queen);
    }
    return heuristicValue == 0;
  }

  GameBoardBase copy();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    if (other is! GameBoardBase) return false;
    return listEquals(queens, other.queens) &&
        heuristicValue == other.heuristicValue;
  }

  @override
  int get hashCode => Object.hashAll([...queens, heuristicValue]);
  bool isQueen({required int column, required int row}) {
    switch (column) {
      case 1:
        return queenAtColumn1.row == row;
      case 2:
        return queenAtColumn2.row == row;
      case 3:
        return queenAtColumn3.row == row;
      case 4:
        return queenAtColumn4.row == row;
      case 5:
        return queenAtColumn5.row == row;
      case 6:
        return queenAtColumn6.row == row;
      case 7:
        return queenAtColumn7.row == row;
      case 8:
        return queenAtColumn8.row == row;
      default:
        throw RangeError.range(column, 1, 8);
    }
  }
}

class GameBoard extends GameBoardBase with GameBoardToStrings {
  const GameBoard._(
    this.queenAtColumn1,
    this.queenAtColumn2,
    this.queenAtColumn3,
    this.queenAtColumn4,
    this.queenAtColumn5,
    this.queenAtColumn6,
    this.queenAtColumn7,
    this.queenAtColumn8,
  );

  factory GameBoard.random() => GameBoard.fresh()..randomize();
  factory GameBoard.fresh() {
    final board = GameBoard._(
      Queen.one(),
      Queen.two(),
      Queen.three(),
      Queen.four(),
      Queen.five(),
      Queen.six(),
      Queen.seven(),
      Queen.eight(),
    );
    for (var queen in board.queens) {
      queen.board = board;
    }
    return board;
  }

  void randomize() {
    for (var queen in queens) {
      queen.randomizePosition();
    }
  }

  @override
  final Queen queenAtColumn1;
  @override
  final Queen queenAtColumn2;
  @override
  final Queen queenAtColumn3;
  @override
  final Queen queenAtColumn4;
  @override
  final Queen queenAtColumn5;
  @override
  final Queen queenAtColumn6;
  @override
  final Queen queenAtColumn7;
  @override
  final Queen queenAtColumn8;

  @override
  GameBoard copy() => GameBoard._(
        queenAtColumn1.copy(),
        queenAtColumn2.copy(),
        queenAtColumn3.copy(),
        queenAtColumn4.copy(),
        queenAtColumn5.copy(),
        queenAtColumn6.copy(),
        queenAtColumn7.copy(),
        queenAtColumn8.copy(),
      );
}
