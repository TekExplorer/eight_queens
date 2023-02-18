import 'package:freezed_annotation/freezed_annotation.dart';

import 'position.dart';

part 'queens_model.freezed.dart';

@Freezed(copyWith: false)
class Queens with _$Queens {
  const Queens._();
  const factory Queens({
    required Map<Position, Position> queens,
    required int heuristic,
  }) = _Queens;

  factory Queens.fromMap(Map<Position, Position> queens) {
    return Queens(
      queens: queens,
      heuristic: calculateHeuristic(queens),
    );
  }

  Queens copyWithUpdate(
    Map<Position, Position> Function(Map<Position, Position> queens) update,
  ) {
    final newQueens = update({...queens});
    return Queens.fromMap(newQueens);
  }

  static int calculateHeuristic(Map<Position, Position> queens) {
    // calculate a heuristic value based on the number of collisions between queens
    // there is always one queen in each column, so we only need to check the rows
    int collisions = 0;

    for (final queen in Position.values) {
      final row = queens[queen]!;

      for (final otherQueen in Position.values) {
        if (otherQueen == queen) continue;

        final otherRow = queens[otherQueen]!;

        if (row == otherRow) {
          collisions++;
        }

        if ((queen.index - otherQueen.index).abs() ==
            (row.index - otherRow.index).abs()) {
          collisions++;
        }
      }
    }

    return collisions ~/ 2;
  }

  List<Queens> findNeighbors() {
    final neighbors = <Queens>[];
    for (final column in Position.values) {
      for (final row in Position.values) {
        if (queens[column] == row) continue;

        final newQueens = copyWithUpdate((queens) {
          return {...queens}..[column] = row;
        });

        neighbors.add(newQueens);
      }
    }
    return neighbors.toSet().toList();
  }

  List<Queens> findBetterNeighbors() {
    final neighbors = findNeighbors();
    return neighbors.where((q) => q.heuristic < heuristic).toSet().toList();
  }
}
