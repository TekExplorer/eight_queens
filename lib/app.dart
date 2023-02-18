import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'providers/queen.dart';
import 'widgets/game_view.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Chess Queens',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.blue,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Chess Queens'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.invalidate(queenHistoryProvider);
            ref.invalidate(queensProvider);
          },
          child: const Icon(Icons.refresh),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Stack(
                fit: StackFit.passthrough,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    // child: GameView(),
                    child: SizedBox(
                      width: 700,
                      child: GameHistoryListView(),
                    ),
                  ),
                  // controls
                  if (!ref.watch(queensProvider).isWin) ...[
                    const Positioned.fill(
                      child: PositionedGameActions(),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PositionedGameActions extends ConsumerWidget {
  const PositionedGameActions({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  ref.read(queensProvider.notifier).findBestNeighbor();
                },
                child: const Icon(Icons.swipe_up_alt),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  ref
                      .read(queenHistoryProvider.notifier)
                      .calculateFull()
                      .timeout(const Duration(seconds: 10));
                },
                label: const Text('Calculate fully'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
