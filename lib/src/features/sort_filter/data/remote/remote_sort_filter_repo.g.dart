// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_sort_filter_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteSortFilterRepoHash() =>
    r'd6f634cb0cf05750f6954fb16fc46e3f0479a974';

/// See also [remoteSortFilterRepo].
@ProviderFor(remoteSortFilterRepo)
final remoteSortFilterRepoProvider =
    AutoDisposeProvider<RemoteSortFilterRepo>.internal(
  remoteSortFilterRepo,
  name: r'remoteSortFilterRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteSortFilterRepoHash,
  dependencies: <ProviderOrFamily>[apiServiceProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    apiServiceProvider,
    ...?apiServiceProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RemoteSortFilterRepoRef = AutoDisposeProviderRef<RemoteSortFilterRepo>;
String _$fetchDevelopersHash() => r'3c3611993a8c20af457702485dba08a3ad59d7ef';

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

/// See also [fetchDevelopers].
@ProviderFor(fetchDevelopers)
const fetchDevelopersProvider = FetchDevelopersFamily();

/// See also [fetchDevelopers].
class FetchDevelopersFamily extends Family<AsyncValue<Response>> {
  /// See also [fetchDevelopers].
  const FetchDevelopersFamily();

  /// See also [fetchDevelopers].
  FetchDevelopersProvider call(
    String devName, {
    CancelToken? cancelToken,
  }) {
    return FetchDevelopersProvider(
      devName,
      cancelToken: cancelToken,
    );
  }

  @override
  FetchDevelopersProvider getProviderOverride(
    covariant FetchDevelopersProvider provider,
  ) {
    return call(
      provider.devName,
      cancelToken: provider.cancelToken,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    remoteSortFilterRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    remoteSortFilterRepoProvider,
    ...?remoteSortFilterRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchDevelopersProvider';
}

/// See also [fetchDevelopers].
class FetchDevelopersProvider extends AutoDisposeFutureProvider<Response> {
  /// See also [fetchDevelopers].
  FetchDevelopersProvider(
    String devName, {
    CancelToken? cancelToken,
  }) : this._internal(
          (ref) => fetchDevelopers(
            ref as FetchDevelopersRef,
            devName,
            cancelToken: cancelToken,
          ),
          from: fetchDevelopersProvider,
          name: r'fetchDevelopersProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchDevelopersHash,
          dependencies: FetchDevelopersFamily._dependencies,
          allTransitiveDependencies:
              FetchDevelopersFamily._allTransitiveDependencies,
          devName: devName,
          cancelToken: cancelToken,
        );

  FetchDevelopersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.devName,
    required this.cancelToken,
  }) : super.internal();

  final String devName;
  final CancelToken? cancelToken;

  @override
  Override overrideWith(
    FutureOr<Response> Function(FetchDevelopersRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchDevelopersProvider._internal(
        (ref) => create(ref as FetchDevelopersRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        devName: devName,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Response> createElement() {
    return _FetchDevelopersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchDevelopersProvider &&
        other.devName == devName &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, devName.hashCode);
    hash = _SystemHash.combine(hash, cancelToken.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchDevelopersRef on AutoDisposeFutureProviderRef<Response> {
  /// The parameter `devName` of this provider.
  String get devName;

  /// The parameter `cancelToken` of this provider.
  CancelToken? get cancelToken;
}

class _FetchDevelopersProviderElement
    extends AutoDisposeFutureProviderElement<Response> with FetchDevelopersRef {
  _FetchDevelopersProviderElement(super.provider);

  @override
  String get devName => (origin as FetchDevelopersProvider).devName;
  @override
  CancelToken? get cancelToken =>
      (origin as FetchDevelopersProvider).cancelToken;
}

String _$fetchTagsHash() => r'7956ea55a1ba8ceddea6a7664fd95f7e4de3fb15';

/// See also [fetchTags].
@ProviderFor(fetchTags)
const fetchTagsProvider = FetchTagsFamily();

/// See also [fetchTags].
class FetchTagsFamily extends Family<AsyncValue<Response>> {
  /// See also [fetchTags].
  const FetchTagsFamily();

  /// See also [fetchTags].
  FetchTagsProvider call(
    String tagName, {
    CancelToken? cancelToken,
  }) {
    return FetchTagsProvider(
      tagName,
      cancelToken: cancelToken,
    );
  }

  @override
  FetchTagsProvider getProviderOverride(
    covariant FetchTagsProvider provider,
  ) {
    return call(
      provider.tagName,
      cancelToken: provider.cancelToken,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    remoteSortFilterRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    remoteSortFilterRepoProvider,
    ...?remoteSortFilterRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchTagsProvider';
}

/// See also [fetchTags].
class FetchTagsProvider extends AutoDisposeFutureProvider<Response> {
  /// See also [fetchTags].
  FetchTagsProvider(
    String tagName, {
    CancelToken? cancelToken,
  }) : this._internal(
          (ref) => fetchTags(
            ref as FetchTagsRef,
            tagName,
            cancelToken: cancelToken,
          ),
          from: fetchTagsProvider,
          name: r'fetchTagsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchTagsHash,
          dependencies: FetchTagsFamily._dependencies,
          allTransitiveDependencies: FetchTagsFamily._allTransitiveDependencies,
          tagName: tagName,
          cancelToken: cancelToken,
        );

  FetchTagsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tagName,
    required this.cancelToken,
  }) : super.internal();

  final String tagName;
  final CancelToken? cancelToken;

  @override
  Override overrideWith(
    FutureOr<Response> Function(FetchTagsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchTagsProvider._internal(
        (ref) => create(ref as FetchTagsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tagName: tagName,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Response> createElement() {
    return _FetchTagsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchTagsProvider &&
        other.tagName == tagName &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tagName.hashCode);
    hash = _SystemHash.combine(hash, cancelToken.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchTagsRef on AutoDisposeFutureProviderRef<Response> {
  /// The parameter `tagName` of this provider.
  String get tagName;

  /// The parameter `cancelToken` of this provider.
  CancelToken? get cancelToken;
}

class _FetchTagsProviderElement
    extends AutoDisposeFutureProviderElement<Response> with FetchTagsRef {
  _FetchTagsProviderElement(super.provider);

  @override
  String get tagName => (origin as FetchTagsProvider).tagName;
  @override
  CancelToken? get cancelToken => (origin as FetchTagsProvider).cancelToken;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
