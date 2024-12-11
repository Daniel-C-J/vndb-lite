// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_selection_remote_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAndSaveP2DataHash() =>
    r'7a931bd424a4784c53101a54960c8e90f87a7d3a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [fetchAndSaveP2Data].
@ProviderFor(fetchAndSaveP2Data)
const fetchAndSaveP2DataProvider = FetchAndSaveP2DataFamily();

/// See also [fetchAndSaveP2Data].
class FetchAndSaveP2DataFamily extends Family<AsyncValue<void>> {
  /// See also [fetchAndSaveP2Data].
  const FetchAndSaveP2DataFamily();

  /// See also [fetchAndSaveP2Data].
  FetchAndSaveP2DataProvider call(
    String vnId,
  ) {
    return FetchAndSaveP2DataProvider(
      vnId,
    );
  }

  @override
  FetchAndSaveP2DataProvider getProviderOverride(
    covariant FetchAndSaveP2DataProvider provider,
  ) {
    return call(
      provider.vnId,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    remoteVnRepoProvider,
    localVnRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    remoteVnRepoProvider,
    ...?remoteVnRepoProvider.allTransitiveDependencies,
    localVnRepoProvider,
    ...?localVnRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchAndSaveP2DataProvider';
}

/// See also [fetchAndSaveP2Data].
class FetchAndSaveP2DataProvider extends AutoDisposeFutureProvider<void> {
  /// See also [fetchAndSaveP2Data].
  FetchAndSaveP2DataProvider(
    String vnId,
  ) : this._internal(
          (ref) => fetchAndSaveP2Data(
            ref as FetchAndSaveP2DataRef,
            vnId,
          ),
          from: fetchAndSaveP2DataProvider,
          name: r'fetchAndSaveP2DataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAndSaveP2DataHash,
          dependencies: FetchAndSaveP2DataFamily._dependencies,
          allTransitiveDependencies:
              FetchAndSaveP2DataFamily._allTransitiveDependencies,
          vnId: vnId,
        );

  FetchAndSaveP2DataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vnId,
  }) : super.internal();

  final String vnId;

  @override
  Override overrideWith(
    FutureOr<void> Function(FetchAndSaveP2DataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAndSaveP2DataProvider._internal(
        (ref) => create(ref as FetchAndSaveP2DataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vnId: vnId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _FetchAndSaveP2DataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAndSaveP2DataProvider && other.vnId == vnId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vnId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAndSaveP2DataRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _FetchAndSaveP2DataProviderElement
    extends AutoDisposeFutureProviderElement<void> with FetchAndSaveP2DataRef {
  _FetchAndSaveP2DataProviderElement(super.provider);

  @override
  String get vnId => (origin as FetchAndSaveP2DataProvider).vnId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
