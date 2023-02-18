import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'position.dart';
import 'queens_model.dart';

part 'queen.freezed.dart';
part 'queen.g.dart';

final queensProvider = queensNotifierProvider;

// the board
@Riverpod(keepAlive: true)
class QueensNotifier extends _$QueensNotifier {
  @override
  Queens build() {
    final queens = <Position, Position>{};

    // randomize
    for (final column in Position.values) {
      queens[column] = Position.values[Random().nextInt(8)];
    }

    return Queens.fromMap(queens);
  }

  int findBestNeighbor() {
    final neighbors = state.findNeighbors();
    if (neighbors.isEmpty) {
      ref.invalidateSelf();
      return 0;
    }
    final best = neighbors.reduce((value, element) {
      if (element.heuristic < value.heuristic) {
        return element;
      }
      return value;
    });
    final numBetter =
        neighbors.where((q) => q.heuristic < state.heuristic).length;

    if (numBetter > 0) {
      state = best;
    } else {
      ref.invalidateSelf();
    }
    return numBetter;
  }
}

@Riverpod(keepAlive: true)
class QueenHistory extends _$QueenHistory {
  @override
  List<HistoryElement> build() {
    ref.listen(queensProvider, (previous, next) {
      state = [
        ...state,
        HistoryElement(
          current: next,
          previous: previous,
          numBetter: 0,
        ),
      ];
      assert(
        state.where((q) => q.actionIntent == GameAction.win).length <= 1,
        'There should only be one win condition',
      );

      assert(
        state.where((q) => q.actionIntent == GameAction.start).length <= 1,
        'There should only be one starting position',
      );
    });
    final first = ref.read(queensProvider);

    return [
      HistoryElement(
        current: first,
      ),
    ];
  }

  Future<void> calculateFull() async {
    // go until win
    while (!ref.read(queensProvider).isWin) {
      if (state.length > 250) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      ref.read(queensProvider.notifier).findBestNeighbor();
    }
  }
}

extension QueensExtensions on Queens {
  bool get isWin => heuristic == 0;
  bool isNeighbor(Queens other) {
    final aQueens = queens;
    final bQueens = other.queens;
    int differences = 0;
    for (final column in Position.values) {
      if (aQueens[column] != bQueens[column]) {
        differences++;
      }
    }
    return differences == 1;
  }

  GameAction get intendedAction {
    final neighbors = findNeighbors();
    final Queens best;
    if (neighbors.isEmpty) {
      return GameAction.unknown;
    } else {
      best = neighbors.reduce((value, element) {
        if (element.heuristic < value.heuristic) {
          return element;
        }
        return value;
      });
    }

    if (best.heuristic == heuristic) {
      return GameAction.reset;
    }

    final numBetterNeighbors =
        neighbors.where((q) => q.heuristic < heuristic).length;

    if (numBetterNeighbors > 0) {
      return GameAction.setBestNeighbor;
    }

    return GameAction.unknown;
  }
}

@freezed
class HistoryElement with _$HistoryElement {
  const HistoryElement._();
  const factory HistoryElement({
    Queens? previous,
    int? numBetter,
    required Queens current,
  }) = _HistoryElement;

  Position? ghostAtColumn(Position position) {
    if (previousAction != GameAction.setBestNeighbor) {
      return null;
    }
    if (previous == null) {
      return null;
    }
    final previousQueen = previous!.queens[position];
    final currentQueen = current.queens[position];
    if (previousQueen == currentQueen) {
      return null;
    }
    return previousQueen;
  }

  GameAction? get previousAction => previous?.intendedAction;

  GameAction get actionIntent => current.intendedAction;
}

enum GameAction {
  start('Start'),
  setBestNeighbor('Set Best Neighbor'),
  unknown('Unknown'),
  reset('Reset'),
  win('Win!');

  const GameAction(this.label);
  final String label;
}
