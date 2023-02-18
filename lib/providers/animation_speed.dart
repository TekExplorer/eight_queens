import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'animation_speed.g.dart';

@Riverpod(keepAlive: true)
class AnimationDuration extends _$AnimationDuration {
  @override
  Duration build() => const Duration(milliseconds: 500);

  void update(int value) => state = Duration(milliseconds: value);
  void pause() => state = Duration.zero;
}
