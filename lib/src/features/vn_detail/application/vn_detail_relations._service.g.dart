// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vn_detail_relations._service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAndSaveP3DataHash() =>
    r'83a93f1c5d3fdf7147ebee5530614a9bd9b81590';

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

/// See also [fetchAndSaveP3Data].
@ProviderFor(fetchAndSaveP3Data)
const fetchAndSaveP3DataProvider = FetchAndSaveP3DataFamily();

/// See also [fetchAndSaveP3Data].
class FetchAndSaveP3DataFamily extends Family<AsyncValue<void>> {
  /// See also [fetchAndSaveP3Data].
  const FetchAndSaveP3DataFamily();

  /// See also [fetchAndSaveP3Data].
  FetchAndSaveP3DataProvider call(
    String vnId,
  ) {
    return FetchAndSaveP3DataProvider(
      vnId,
    );
  }

  @override
  FetchAndSaveP3DataProvider getProviderOverride(
    covariant FetchAndSaveP3DataProvider provider,
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
  String? get name => r'fetchAndSaveP3DataProvider';
}

/// See also [fetchAndSaveP3Data].
class FetchAndSaveP3DataProvider extends AutoDisposeFutureProvider<void> {
  /// See also [fetchAndSaveP3Data].
  FetchAndSaveP3DataProvider(
    String vnId,
  ) : this._internal(
          (ref) => fetchAndSaveP3Data(
            ref as FetchAndSaveP3DataRef,
            vnId,
          ),
          from: fetchAndSaveP3DataProvider,
          name: r'fetchAndSaveP3DataProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAndSaveP3DataHash,
          dependencies: FetchAndSaveP3DataFamily._dependencies,
          allTransitiveDependencies:
              FetchAndSaveP3DataFamily._allTransitiveDependencies,
          vnId: vnId,
        );

  FetchAndSaveP3DataProvider._internal(
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
    FutureOr<void> Function(FetchAndSaveP3DataRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAndSaveP3DataProvider._internal(
        (ref) => create(ref as FetchAndSaveP3DataRef),
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
    return _FetchAndSaveP3DataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAndSaveP3DataProvider && other.vnId == vnId;
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
mixin FetchAndSaveP3DataRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _FetchAndSaveP3DataProviderElement
    extends AutoDisposeFutureProviderElement<void> with FetchAndSaveP3DataRef {
  _FetchAndSaveP3DataProviderElement(super.provider);

  @override
  String get vnId => (origin as FetchAndSaveP3DataProvider).vnId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
