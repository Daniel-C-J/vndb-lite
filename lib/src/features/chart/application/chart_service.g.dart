// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getStatsChartHash() => r'20a372f37e3110da61973ef05a49924cdcd648d9';

/// See also [getStatsChart].
@ProviderFor(getStatsChart)
final getStatsChartProvider = AutoDisposeFutureProvider<void>.internal(
  getStatsChart,
  name: r'getStatsChartProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getStatsChartHash,
  dependencies: <ProviderOrFamily>[
    localChartRepoProvider,
    remoteChartRepoProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    localChartRepoProvider,
    ...?localChartRepoProvider.allTransitiveDependencies,
    remoteChartRepoProvider,
    ...?remoteChartRepoProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetStatsChartRef = AutoDisposeFutureProviderRef<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
