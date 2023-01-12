import 'package:eight_queens/widgets/game_board_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_hero/local_hero.dart';

import 'game/game_board.dart';
import 'game/queen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late GameBoard visibleGameBoard;
  late GameBoard currentGameBoard;

  Set<GameBoard> neighborStates = {};
  List<GameBoard> get sortedNeighborStates => neighborStates.toList()
    ..sort((a, b) => a.heuristicValue.compareTo(b.heuristicValue));

  GameBoard? get bestNeighborState {
    if (neighborStates.isEmpty) return null;
    return sortedNeighborStates.first;
  }

  List<GameBoard> get betterNeighborStates {
    if (neighborStates.isEmpty) return [];
    return sortedNeighborStates
        .where(
          (state) => state.heuristicValue < currentGameBoard.heuristicValue,
        )
        .toList();
  }

  bool? generatorCanceled;

  void generateNeighborStates() async {
    if (generatorCanceled != null) return;
    neighborStates.clear();

    generatorCanceled = false;
    for (var queen in currentGameBoard.queens) {
      if (generatorCanceled != false) {
        visibleGameBoard = currentGameBoard;
        generatorCanceled = null;
        setState(() {});

        return;
      }
      await generateNeighborStatesForOneQueen(queen);
    }
    visibleGameBoard = currentGameBoard;
    generatorCanceled = null;
    setState(() {});

    afterCompletion();
  }

  void afterCompletion() {
    final bestNeighborState = this.bestNeighborState;
    if (bestNeighborState == null) return;
    final bestNeighborHeuristic = bestNeighborState.heuristicValue;
    if (bestNeighborHeuristic == 0) {
      currentGameBoard = bestNeighborState;
      visibleGameBoard = currentGameBoard;
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        if (mounted) {
          var messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(const SnackBar(
            content: Text("HAHA! We've Won!"),
            backgroundColor: Colors.greenAccent,
          ));
        }
      });
      setState(() {});
    } else if (bestNeighborHeuristic < currentGameBoard.heuristicValue) {
      currentGameBoard = bestNeighborState;
      visibleGameBoard = currentGameBoard;
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        if (mounted) {
          var messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(const SnackBar(
            content: Text('Better neighbor state found!'),
            backgroundColor: Colors.yellowAccent,
          ));
        }
      });
      setState(() {});
    } else if (bestNeighborHeuristic == currentGameBoard.heuristicValue) {
      SchedulerBinding.instance.addPostFrameCallback((duration) {
        if (mounted) {
          var messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(const SnackBar(
            content: Text("On no! We've hit a peak!"),
            backgroundColor: Colors.redAccent,
          ));
        }
      });
    }
  }

  Future<void> generateNeighborStatesForOneQueen(Queen queen) async {
    debugPrint('Source queen: $queen');
    final copyBoard = currentGameBoard.copy();

    visibleGameBoard = copyBoard;
    final localQueen = visibleGameBoard.queens.firstWhere(
      (q) => q.column == queen.column,
    );
    for (var i = 0; i < 8; i++) {
      if (generatorCanceled != false) {
        visibleGameBoard = currentGameBoard;
        generatorCanceled = null;
        return;
      }
      await moveQueenThenWait(localQueen, const Duration(milliseconds: 50));
      neighborStates.add(copyBoard.copy());
    }
    // visibleGameBoard = currentGameBoard;
    if (mounted) setState(() {});
    await Future.delayed(const Duration(milliseconds: 30));
  }

  Future<void> moveQueenThenWait(Queen queen, Duration duration) async {
    // debugPrint('Local Queen: $queen');
    queen.moveDown();
    // debugPrint('Local Queen x2: $queen');
    if (mounted) setState(() {});
    await Future.delayed(duration);
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    currentGameBoard = GameBoard.random();
    visibleGameBoard = currentGameBoard;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: LocalHeroScope(
                    // duration: const Duration(milliseconds: 50),
                    // curve: Curves.bounceInOut,
                    child: PageStorage(
                      bucket: PageStorageBucket(),
                      child: GameBoardWidget(
                        gameBoard: visibleGameBoard,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Heuristic'),
                if (identical(visibleGameBoard, currentGameBoard) &&
                    neighborStates.isEmpty)
                  Text('${visibleGameBoard.heuristicValue}')
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Stored: ${currentGameBoard.heuristicValue}'),
                      if (!identical(visibleGameBoard, currentGameBoard)) ...[
                        const SizedBox(width: 8),
                        Text('Current: ${visibleGameBoard.heuristicValue}'),
                      ],
                    ],
                  ),
                if (bestNeighborState != null &&
                    betterNeighborStates.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                      'Best (Count): ${bestNeighborState!.heuristicValue} (${betterNeighborStates.length})'),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Flexible(
                      fit: FlexFit.tight,
                      child: TextButton.icon(
                        onPressed: (generatorCanceled != null)
                            ? null
                            : () {
                                setState(() {
                                  neighborStates.clear();
                                  visibleGameBoard.randomize();
                                });
                              },
                        icon: const QueenWidget(
                          child: Icon(
                            Icons.refresh,
                            color: Colors.transparent,
                          ),
                        ),
                        label: const Text('Refresh'),
                      ),
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        onPressed: () {
                          generateNeighborStates();
                          // generateNeighborStatesForOneQueen(
                          //   visibleGameBoard.queenAtColumn1,
                          // );
                        },
                        child: const Icon(Icons.play_arrow),
                      ),
                    ),
                    if (generatorCanceled != null)
                      Flexible(
                        fit: FlexFit.tight,
                        child: ElevatedButton(
                          onPressed: generatorCanceled == true
                              ? null
                              : () {
                                  generatorCanceled = true;
                                  setState(() {});
                                },
                          child: const Text('Cancel'),
                        ),
                      )
                    else
                      const Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(),
                      ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
