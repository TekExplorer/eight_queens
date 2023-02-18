// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$queensNotifierHash() => r'064f731019bbc7b8878861524d7269d3f937a765';

/// See also [QueensNotifier].
@ProviderFor(QueensNotifier)
final queensNotifierProvider =
    NotifierProvider<QueensNotifier, Queens>.internal(
  QueensNotifier.new,
  name: r'queensNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$queensNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QueensNotifier = Notifier<Queens>;
String _$queenHistoryHash() => r'8e94759b3fc0c7e62642bde7cdb49e8ca8e0532a';

/// See also [QueenHistory].
@ProviderFor(QueenHistory)
final queenHistoryProvider =
    NotifierProvider<QueenHistory, List<HistoryElement>>.internal(
  QueenHistory.new,
  name: r'queenHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$queenHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QueenHistory = Notifier<List<HistoryElement>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
