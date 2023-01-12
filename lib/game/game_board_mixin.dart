import 'game_board.dart';

mixin GameBoardToStrings on GameBoardBase {
  /// Returns a string representation of the board, with 1s and 0s.
  ///
  /// Looks like this:
  ///```
  /// 0,0,0,0,1,0,0,0,0,0
  /// 0,0,0,0,0,0,0,0,0,0
  /// 0,0,0,0,0,0,0,0,0,0
  /// 0,0,0,1,0,0,0,0,0,0
  /// 1,0,1,0,0,0,0,0,0,0
  /// 0,0,0,0,0,0,0,0,0,0
  /// 0,0,0,0,0,0,0,1,1,0
  /// 0,0,0,0,0,0,1,0,0,0
  /// 0,0,0,0,0,1,0,0,0,1
  /// 0,1,0,0,0,0,0,0,0,0
  /// ```
  String to1sAnd0s() {
    final sb = StringBuffer();
    for (var row = MAX_INDEX; row >= MIN_INDEX; row--) {
      for (var column = MIN_INDEX; column <= MAX_INDEX; column++) {
        final queen = queens[column - 1];
        if (queen.row == row) {
          sb.write('1');
        } else {
          sb.write('0');
        }
        if (column < MAX_INDEX) {
          sb.write(',');
        }
      }
    }
    return sb.toString();
  }
}
// ignore: constant_identifier_names
const int MAX_INDEX = 8;
// ignore: constant_identifier_names
const int MIN_INDEX = 1;
