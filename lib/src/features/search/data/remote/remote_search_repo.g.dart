// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_search_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteSearchRepoHash() => r'a6cc9b5e90cb5e64fbf41285802645b300b905cc';

/// See also [remoteSearchRepo].
@ProviderFor(remoteSearchRepo)
final remoteSearchRepoProvider =
    AutoDisposeProvider<RemoteSearchRepoImpl>.internal(
  remoteSearchRepo,
  name: r'remoteSearchRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteSearchRepoHash,
  dependencies: <ProviderOrFamily>[apiServiceProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    apiServiceProvider,
    ...?apiServiceProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RemoteSearchRepoRef = AutoDisposeProviderRef<RemoteSearchRepoImpl>;
String _$remoteSearchVnHash() => r'0a775e09ceed3cdbd2f2028a037017cc24f4d833';

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

/// See also [remoteSearchVn].
@ProviderFor(remoteSearchVn)
const remoteSearchVnProvider = RemoteSearchVnFamily();

/// See also [remoteSearchVn].
class RemoteSearchVnFamily extends Family<AsyncValue<Response>> {
  /// See also [remoteSearchVn].
  const RemoteSearchVnFamily();

  /// See also [remoteSearchVn].
  RemoteSearchVnProvider call(
    GenericPost requestData, {
    CancelToken? cancelToken,
  }) {
    return RemoteSearchVnProvider(
      requestData,
      cancelToken: cancelToken,
    );
  }

  @override
  RemoteSearchVnProvider getProviderOverride(
    covariant RemoteSearchVnProvider provider,
  ) {
    return call(
      provider.requestData,
      cancelToken: provider.cancelToken,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    remoteSearchRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    remoteSearchRepoProvider,
    ...?remoteSearchRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'remoteSearchVnProvider';
}

/// See also [remoteSearchVn].
class RemoteSearchVnProvider extends AutoDisposeFutureProvider<Response> {
  /// See also [remoteSearchVn].
  RemoteSearchVnProvider(
    GenericPost requestData, {
    CancelToken? cancelToken,
  }) : this._internal(
          (ref) => remoteSearchVn(
            ref as RemoteSearchVnRef,
            requestData,
            cancelToken: cancelToken,
          ),
          from: remoteSearchVnProvider,
          name: r'remoteSearchVnProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$remoteSearchVnHash,
          dependencies: RemoteSearchVnFamily._dependencies,
          allTransitiveDependencies:
              RemoteSearchVnFamily._allTransitiveDependencies,
          requestData: requestData,
          cancelToken: cancelToken,
        );

  RemoteSearchVnProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.requestData,
    required this.cancelToken,
  }) : super.internal();

  final GenericPost requestData;
  final CancelToken? cancelToken;

  @override
  Override overrideWith(
    FutureOr<Response> Function(RemoteSearchVnRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoteSearchVnProvider._internal(
        (ref) => create(ref as RemoteSearchVnRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        requestData: requestData,
        cancelToken: cancelToken,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Response> createElement() {
    return _RemoteSearchVnProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoteSearchVnProvider &&
        other.requestData == requestData &&
        other.cancelToken == cancelToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, requestData.hashCode);
    hash = _SystemHash.combine(hash, cancelToken.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RemoteSearchVnRef on AutoDisposeFutureProviderRef<Response> {
  /// The parameter `requestData` of this provider.
  GenericPost get requestData;

  /// The parameter `cancelToken` of this provider.
  CancelToken? get cancelToken;
}

class _RemoteSearchVnProviderElement
    extends AutoDisposeFutureProviderElement<Response> with RemoteSearchVnRef {
  _RemoteSearchVnProviderElement(super.provider);

  @override
  GenericPost get requestData => (origin as RemoteSearchVnProvider).requestData;
  @override
  CancelToken? get cancelToken =>
      (origin as RemoteSearchVnProvider).cancelToken;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
