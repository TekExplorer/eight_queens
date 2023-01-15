import 'package:flutter/material.dart';

import 'cell.dart';

class GameColumnWidget extends StatelessWidget {
  const GameColumnWidget({
    super.key,
    required this.rowWithQueen,
    required this.column,
  });
  final int rowWithQueen;
  final int column;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 8; row >= 1; row--)
          Expanded(
            child: GameCell(
              column: column,
              row: row,
              builder: (ctx, isWhiteSquare) => row == rowWithQueen
                  ? SizedBox.expand(
                      child: QueenWidget(
                        accentColor: isWhiteSquare
                            ? Colors.lightBlueAccent
                            : Colors.white.withOpacity(.75),
                      ),
                    )
                  : const SizedBox.expand(),
            ),
          ),
      ],
    );
  }
}
