// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_home_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localHomeRepoHash() => r'5c29abceceb5a17ad9fdfa698da41266ece1569e';

/// See also [localHomeRepo].
@ProviderFor(localHomeRepo)
final localHomeRepoProvider = AutoDisposeProvider<LocalHomeRepoImpl>.internal(
  localHomeRepo,
  name: r'localHomeRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localHomeRepoHash,
  dependencies: <ProviderOrFamily>[sharedPrefProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    sharedPrefProvider,
    ...?sharedPrefProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalHomeRepoRef = AutoDisposeProviderRef<LocalHomeRepoImpl>;
String _$fetchCachedPreviewHash() =>
    r'0d940530615fc873855eeaa3ed42187239633a10';

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

/// See also [fetchCachedPreview].
@ProviderFor(fetchCachedPreview)
const fetchCachedPreviewProvider = FetchCachedPreviewFamily();

/// See also [fetchCachedPreview].
class FetchCachedPreviewFamily extends Family<AsyncValue<List<String>>> {
  /// See also [fetchCachedPreview].
  const FetchCachedPreviewFamily();

  /// See also [fetchCachedPreview].
  FetchCachedPreviewProvider call(
    int maxPreviewItem, {
    required String cacheKey,
  }) {
    return FetchCachedPreviewProvider(
      maxPreviewItem,
      cacheKey: cacheKey,
    );
  }

  @override
  FetchCachedPreviewProvider getProviderOverride(
    covariant FetchCachedPreviewProvider provider,
  ) {
    return call(
      provider.maxPreviewItem,
      cacheKey: provider.cacheKey,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    localHomeRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    localHomeRepoProvider,
    ...?localHomeRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchCachedPreviewProvider';
}

/// See also [fetchCachedPreview].
class FetchCachedPreviewProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [fetchCachedPreview].
  FetchCachedPreviewProvider(
    int maxPreviewItem, {
    required String cacheKey,
  }) : this._internal(
          (ref) => fetchCachedPreview(
            ref as FetchCachedPreviewRef,
            maxPreviewItem,
            cacheKey: cacheKey,
          ),
          from: fetchCachedPreviewProvider,
          name: r'fetchCachedPreviewProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchCachedPreviewHash,
          dependencies: FetchCachedPreviewFamily._dependencies,
          allTransitiveDependencies:
              FetchCachedPreviewFamily._allTransitiveDependencies,
          maxPreviewItem: maxPreviewItem,
          cacheKey: cacheKey,
        );

  FetchCachedPreviewProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.maxPreviewItem,
    required this.cacheKey,
  }) : super.internal();

  final int maxPreviewItem;
  final String cacheKey;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(FetchCachedPreviewRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchCachedPreviewProvider._internal(
        (ref) => create(ref as FetchCachedPreviewRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        maxPreviewItem: maxPreviewItem,
        cacheKey: cacheKey,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _FetchCachedPreviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchCachedPreviewProvider &&
        other.maxPreviewItem == maxPreviewItem &&
        other.cacheKey == cacheKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, maxPreviewItem.hashCode);
    hash = _SystemHash.combine(hash, cacheKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchCachedPreviewRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `maxPreviewItem` of this provider.
  int get maxPreviewItem;

  /// The parameter `cacheKey` of this provider.
  String get cacheKey;
}

class _FetchCachedPreviewProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with FetchCachedPreviewRef {
  _FetchCachedPreviewProviderElement(super.provider);

  @override
  int get maxPreviewItem =>
      (origin as FetchCachedPreviewProvider).maxPreviewItem;
  @override
  String get cacheKey => (origin as FetchCachedPreviewProvider).cacheKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
