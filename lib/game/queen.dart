import 'dart:math';

import 'package:eight_queens/game/game_board.dart';

import 'game_board_mixin.dart';

class QueenOne extends Queen {
  QueenOne() : super._(1);
  @override
  QueenOne copy() => QueenOne()..setFrom(this);
}

class QueenTwo extends Queen {
  QueenTwo() : super._(2);
  @override
  QueenTwo copy() => QueenTwo()..setFrom(this);
}

class QueenThree extends Queen {
  QueenThree() : super._(3);
  @override
  QueenThree copy() => QueenThree()..setFrom(this);
}

class QueenFour extends Queen {
  QueenFour() : super._(4);
  @override
  QueenFour copy() => QueenFour()..setFrom(this);
}

class QueenFive extends Queen {
  QueenFive() : super._(5);
  @override
  QueenFive copy() => QueenFive()..setFrom(this);
}

class QueenSix extends Queen {
  QueenSix() : super._(6);

  @override
  QueenSix copy() => QueenSix()..setFrom(this);
}

class QueenSeven extends Queen {
  QueenSeven() : super._(7);
  @override
  QueenSeven copy() => QueenSeven()..setFrom(this);
}

class QueenEight extends Queen {
  QueenEight() : super._(8);
  @override
  QueenEight copy() => QueenEight()..setFrom(this);
}

abstract class Queen {
  Queen._(this.column);
  factory Queen.one() = QueenOne;
  factory Queen.two() = QueenTwo;
  factory Queen.three() = QueenThree;
  factory Queen.four() = QueenFour;
  factory Queen.five() = QueenFive;
  factory Queen.six() = QueenSix;
  factory Queen.seven() = QueenSeven;
  factory Queen.eight() = QueenEight;
  void setFrom(Queen other) {
    _positionInColumn = other._positionInColumn;
    board = other.board;
  }

  late final GameBoard board;
  final int column;
  int get row => _positionInColumn.row;
  QueenPosition _positionInColumn = QueenPosition._unset;
  void reset() => _positionInColumn = QueenPosition._unset;

  bool get isUnset => _positionInColumn == QueenPosition._unset;

  void moveToRow(int row) {
    if (row <= MIN_INDEX || row >= MAX_INDEX) {
      _throwRangeError(row);
    }
    _positionInColumn = QueenPosition.fromRow(row);
  }

  void moveUp() {
    // if (_positionInColumn == QueenPosition.row1) {
    //   _throwRangeError(row);
    // }
    _positionInColumn = _positionInColumn.posAbove;
  }

  void moveDown() {
    // if (_positionInColumn == QueenPosition.row8) {
    //   _throwRangeError(row);
    // }
    _positionInColumn = _positionInColumn.posBelow;
  }

  void randomizePosition() {
    _positionInColumn = QueenPosition.random();
  }

  bool collidesWithQueen(Queen other) {
    if (isUnset) {
      throw QueenNotOnBoardError(this);
    }
    if (other.isUnset) {
      throw QueenNotOnBoardError(other);
    }

    return collidesWith(row: other.row, column: other.column);
  }

  bool collidesWith({required int row, required int column}) {
    if (row == this.row) return true;
    if (column == this.column) return true;
    // Diagonal collision
    if ((row - this.row).abs() == (column - this.column).abs()) return true;

    // No collision
    return false;
  }

  @override
  String toString() {
    if (isUnset) return 'Queen at column $column, !!not on board!!';
    return '$runtimeType at column $column, row $row';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Queen) return false;
    return other.column == column;
  }

  @override
  int get hashCode => column.hashCode;

  Queen copy();
}

class QueenNotOnBoardError implements Exception {
  const QueenNotOnBoardError(this.queen);
  final Queen queen;
  @override
  String toString() => 'Queen $queen is not on the board';
}

enum QueenPosition {
  _unset(-1),
  row1(1),
  row2(2),
  row3(3),
  row4(4),
  row5(5),
  row6(6),
  row7(7),
  row8(8);

  factory QueenPosition.random() => QueenPosition.fromRow(
        Random().nextInt(MAX_INDEX) + 1,
      );

  factory QueenPosition.fromRow(int row) {
    if (row < MIN_INDEX || row > MAX_INDEX) {
      _throwRangeError(row);
    }
    return QueenPosition.values.firstWhere((pos) => pos.row == row);
  }

  final int row;
  QueenPosition get posAbove {
    if (this == QueenPosition._unset) {
      throw StateError('Cannot move unset queen');
    }

    if (this == QueenPosition.row1) return QueenPosition.row8;
    return QueenPosition.values[row - 1];
  }

  QueenPosition get posBelow {
    if (this == QueenPosition._unset) {
      throw StateError('Cannot move unset queen');
    }

    if (this == QueenPosition.row8) return QueenPosition.row1;
    return QueenPosition.values[row + 1];
  }

  const QueenPosition(this.row);
}

Never _throwRangeError(int index) {
  throw RangeError.range(index, MIN_INDEX, MAX_INDEX);
}
