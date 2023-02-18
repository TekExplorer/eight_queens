// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queens_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Queens {
  Map<Position, Position> get queens => throw _privateConstructorUsedError;
  int get heuristic => throw _privateConstructorUsedError;
}

/// @nodoc

class _$_Queens extends _Queens {
  const _$_Queens(
      {required final Map<Position, Position> queens, required this.heuristic})
      : _queens = queens,
        super._();

  final Map<Position, Position> _queens;
  @override
  Map<Position, Position> get queens {
    if (_queens is EqualUnmodifiableMapView) return _queens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_queens);
  }

  @override
  final int heuristic;

  @override
  String toString() {
    return 'Queens(queens: $queens, heuristic: $heuristic)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Queens &&
            const DeepCollectionEquality().equals(other._queens, _queens) &&
            (identical(other.heuristic, heuristic) ||
                other.heuristic == heuristic));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_queens), heuristic);
}

abstract class _Queens extends Queens {
  const factory _Queens(
      {required final Map<Position, Position> queens,
      required final int heuristic}) = _$_Queens;
  const _Queens._() : super._();

  @override
  Map<Position, Position> get queens;
  @override
  int get heuristic;
}
