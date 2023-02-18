import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/position.dart';
import '../providers/queen.dart';
import '../providers/queens_model.dart';
import 'game_column.dart';

class EphemeralGameView extends ConsumerWidget {
  const EphemeralGameView(
    this.queens, {
    super.key,
    required this.ghostBuilder,
  });
  final Queens queens;
  final Position? Function(Position column) ghostBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileSizeBasedOnWidth = constraints.maxWidth / 8;
        final double tileSizeBasedOnHeight = constraints.maxHeight / 8;

        final double tileSize = tileSizeBasedOnWidth < tileSizeBasedOnHeight
            ? tileSizeBasedOnWidth
            : tileSizeBasedOnHeight;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final Position column in Position.values)
              SizedBox(
                width: tileSize,
                child: GameColumn(
                  column: column,
                  queen: queens.queens[column]!,
                  ghost: ghostBuilder(column),
                ),
              ),
          ],
        );
      },
    );
  }
}

class GameHistoryListView extends HookConsumerWidget {
  const GameHistoryListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(
      () => ScrollController(),
      const [],
    );
    final history = ref.watch(queenHistoryProvider);
    ref.listen(queenHistoryProvider, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    });
    // ref.listen(queensProvider, (_, next) {
    //   if (next.isWin) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('You win!'),

    //       ),
    //     );
    //   }
    // });

    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileSizeBasedOnWidth = constraints.maxWidth / 8;
        return ListView.builder(
          controller: controller,
          // itemExtent: (tileSizeBasedOnWidth * 8) + (80 * 2),
          itemCount: history.length + 1,
          itemBuilder: (context, index) {
            if (index == history.length) {
              return const SizedBox(height: 80);
            }
            var historyState = history[index];
            final queens = historyState.current;
            return SizedBox(
              width: tileSizeBasedOnWidth,
              child: Card(
                color: historyState.current.isWin
                    ? Colors.green.shade900
                    : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(
                    width: 3,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(index == 0
                                  ? 'Starting Position'
                                  : 'Move $index'),
                              subtitle: historyState.previousAction != null
                                  ? Text(historyState.previousAction!.label)
                                  : null,
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text('New Heuristic'),
                              subtitle: Text('${queens.heuristic} collisions'),
                            ),
                          ),
                        ],
                      ),
                      EphemeralGameView(
                        queens,
                        ghostBuilder: (col) {
                          final ghost = historyState.ghostAtColumn(col);
                          if (ghost != null) {
                            return ghost;
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text('Better Neighbors'),
                              subtitle: Text(
                                  'Found ${queens.findBetterNeighbors().length}'),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(historyState.current.isWin
                                  ? 'Solution Found!'
                                  : 'Intent'),
                              subtitle: historyState.current.isWin
                                  ? null
                                  : Text(
                                      'Will ${historyState.actionIntent.label}'),
                            ),
                          ),
                        ],
                      ),
                      if (index == history.length - 1) ...[
                        const Divider(),
                        ListTile(
                          title: const Text('Number of resets'),
                          trailing: Text(
                              '${history.where((q) => q.actionIntent == GameAction.reset).length}'),
                        ),
                        ListTile(
                          title: const Text('Number of state changes'),
                          trailing: Text('${history.length - 1}'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
