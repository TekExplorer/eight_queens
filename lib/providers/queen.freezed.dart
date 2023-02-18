// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queen.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HistoryElement {
  Queens? get previous => throw _privateConstructorUsedError;
  int? get numBetter => throw _privateConstructorUsedError;
  Queens get current => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HistoryElementCopyWith<HistoryElement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryElementCopyWith<$Res> {
  factory $HistoryElementCopyWith(
          HistoryElement value, $Res Function(HistoryElement) then) =
      _$HistoryElementCopyWithImpl<$Res, HistoryElement>;
  @useResult
  $Res call({Queens? previous, int? numBetter, Queens current});
}

/// @nodoc
class _$HistoryElementCopyWithImpl<$Res, $Val extends HistoryElement>
    implements $HistoryElementCopyWith<$Res> {
  _$HistoryElementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? previous = freezed,
    Object? numBetter = freezed,
    Object? current = null,
  }) {
    return _then(_value.copyWith(
      previous: freezed == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as Queens?,
      numBetter: freezed == numBetter
          ? _value.numBetter
          : numBetter // ignore: cast_nullable_to_non_nullable
              as int?,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as Queens,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HistoryElementCopyWith<$Res>
    implements $HistoryElementCopyWith<$Res> {
  factory _$$_HistoryElementCopyWith(
          _$_HistoryElement value, $Res Function(_$_HistoryElement) then) =
      __$$_HistoryElementCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Queens? previous, int? numBetter, Queens current});
}

/// @nodoc
class __$$_HistoryElementCopyWithImpl<$Res>
    extends _$HistoryElementCopyWithImpl<$Res, _$_HistoryElement>
    implements _$$_HistoryElementCopyWith<$Res> {
  __$$_HistoryElementCopyWithImpl(
      _$_HistoryElement _value, $Res Function(_$_HistoryElement) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? previous = freezed,
    Object? numBetter = freezed,
    Object? current = null,
  }) {
    return _then(_$_HistoryElement(
      previous: freezed == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as Queens?,
      numBetter: freezed == numBetter
          ? _value.numBetter
          : numBetter // ignore: cast_nullable_to_non_nullable
              as int?,
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as Queens,
    ));
  }
}

/// @nodoc

class _$_HistoryElement extends _HistoryElement {
  const _$_HistoryElement(
      {this.previous, this.numBetter, required this.current})
      : super._();

  @override
  final Queens? previous;
  @override
  final int? numBetter;
  @override
  final Queens current;

  @override
  String toString() {
    return 'HistoryElement(previous: $previous, numBetter: $numBetter, current: $current)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HistoryElement &&
            (identical(other.previous, previous) ||
                other.previous == previous) &&
            (identical(other.numBetter, numBetter) ||
                other.numBetter == numBetter) &&
            (identical(other.current, current) || other.current == current));
  }

  @override
  int get hashCode => Object.hash(runtimeType, previous, numBetter, current);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HistoryElementCopyWith<_$_HistoryElement> get copyWith =>
      __$$_HistoryElementCopyWithImpl<_$_HistoryElement>(this, _$identity);
}

abstract class _HistoryElement extends HistoryElement {
  const factory _HistoryElement(
      {final Queens? previous,
      final int? numBetter,
      required final Queens current}) = _$_HistoryElement;
  const _HistoryElement._() : super._();

  @override
  Queens? get previous;
  @override
  int? get numBetter;
  @override
  Queens get current;
  @override
  @JsonKey(ignore: true)
  _$$_HistoryElementCopyWith<_$_HistoryElement> get copyWith =>
      throw _privateConstructorUsedError;
}
