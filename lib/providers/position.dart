import 'dart:math';

enum Position {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight;

  factory Position.random() => Position.values[Random().nextInt(8)];

  factory Position.fromIndex(int index) {
    if (index < 0) {
      return Position.values[7];
    } else if (index > 7) {
      return Position.values[0];
    }
    return Position.values[index];
  }

  Position get up => Position.fromIndex(index - 1);
  Position get down => Position.fromIndex(index + 1);
}
