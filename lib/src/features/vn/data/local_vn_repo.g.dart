// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_vn_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localVnRepoHash() => r'dd8b14ad372e062d9b64dcfa653176eac54af712';

/// See also [localVnRepo].
@ProviderFor(localVnRepo)
final localVnRepoProvider = AutoDisposeProvider<LocalVnRepo>.internal(
  localVnRepo,
  name: r'localVnRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localVnRepoHash,
  dependencies: <ProviderOrFamily>[sharedPrefProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    sharedPrefProvider,
    ...?sharedPrefProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalVnRepoRef = AutoDisposeProviderRef<LocalVnRepo>;
String _$getP1Hash() => r'de7d94bfe96a05b23c662f98d6e0c36b6c6dfa34';

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

/// See also [getP1].
@ProviderFor(getP1)
const getP1Provider = GetP1Family();

/// See also [getP1].
class GetP1Family extends Family<AsyncValue<VnDataPhase01?>> {
  /// See also [getP1].
  const GetP1Family();

  /// See also [getP1].
  GetP1Provider call(
    String vnId,
  ) {
    return GetP1Provider(
      vnId,
    );
  }

  @override
  GetP1Provider getProviderOverride(
    covariant GetP1Provider provider,
  ) {
    return call(
      provider.vnId,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    localVnRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    localVnRepoProvider,
    ...?localVnRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getP1Provider';
}

/// See also [getP1].
class GetP1Provider extends AutoDisposeFutureProvider<VnDataPhase01?> {
  /// See also [getP1].
  GetP1Provider(
    String vnId,
  ) : this._internal(
          (ref) => getP1(
            ref as GetP1Ref,
            vnId,
          ),
          from: getP1Provider,
          name: r'getP1Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getP1Hash,
          dependencies: GetP1Family._dependencies,
          allTransitiveDependencies: GetP1Family._allTransitiveDependencies,
          vnId: vnId,
        );

  GetP1Provider._internal(
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
    FutureOr<VnDataPhase01?> Function(GetP1Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetP1Provider._internal(
        (ref) => create(ref as GetP1Ref),
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
  AutoDisposeFutureProviderElement<VnDataPhase01?> createElement() {
    return _GetP1ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetP1Provider && other.vnId == vnId;
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
mixin GetP1Ref on AutoDisposeFutureProviderRef<VnDataPhase01?> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _GetP1ProviderElement
    extends AutoDisposeFutureProviderElement<VnDataPhase01?> with GetP1Ref {
  _GetP1ProviderElement(super.provider);

  @override
  String get vnId => (origin as GetP1Provider).vnId;
}

String _$getP2Hash() => r'07963dfa2534e40c2c6f9f04a4d21bedc51ab743';

/// See also [getP2].
@ProviderFor(getP2)
const getP2Provider = GetP2Family();

/// See also [getP2].
class GetP2Family extends Family<AsyncValue<VnDataPhase02?>> {
  /// See also [getP2].
  const GetP2Family();

  /// See also [getP2].
  GetP2Provider call(
    String vnId,
  ) {
    return GetP2Provider(
      vnId,
    );
  }

  @override
  GetP2Provider getProviderOverride(
    covariant GetP2Provider provider,
  ) {
    return call(
      provider.vnId,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    localVnRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    localVnRepoProvider,
    ...?localVnRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getP2Provider';
}

/// See also [getP2].
class GetP2Provider extends AutoDisposeFutureProvider<VnDataPhase02?> {
  /// See also [getP2].
  GetP2Provider(
    String vnId,
  ) : this._internal(
          (ref) => getP2(
            ref as GetP2Ref,
            vnId,
          ),
          from: getP2Provider,
          name: r'getP2Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getP2Hash,
          dependencies: GetP2Family._dependencies,
          allTransitiveDependencies: GetP2Family._allTransitiveDependencies,
          vnId: vnId,
        );

  GetP2Provider._internal(
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
    FutureOr<VnDataPhase02?> Function(GetP2Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetP2Provider._internal(
        (ref) => create(ref as GetP2Ref),
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
  AutoDisposeFutureProviderElement<VnDataPhase02?> createElement() {
    return _GetP2ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetP2Provider && other.vnId == vnId;
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
mixin GetP2Ref on AutoDisposeFutureProviderRef<VnDataPhase02?> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _GetP2ProviderElement
    extends AutoDisposeFutureProviderElement<VnDataPhase02?> with GetP2Ref {
  _GetP2ProviderElement(super.provider);

  @override
  String get vnId => (origin as GetP2Provider).vnId;
}

String _$getP3Hash() => r'd7a0a434e248a14b561f07a8fb92adaaa35e4e45';

/// See also [getP3].
@ProviderFor(getP3)
const getP3Provider = GetP3Family();

/// See also [getP3].
class GetP3Family extends Family<AsyncValue<VnDataPhase03?>> {
  /// See also [getP3].
  const GetP3Family();

  /// See also [getP3].
  GetP3Provider call(
    String vnId,
  ) {
    return GetP3Provider(
      vnId,
    );
  }

  @override
  GetP3Provider getProviderOverride(
    covariant GetP3Provider provider,
  ) {
    return call(
      provider.vnId,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    localVnRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    localVnRepoProvider,
    ...?localVnRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getP3Provider';
}

/// See also [getP3].
class GetP3Provider extends AutoDisposeFutureProvider<VnDataPhase03?> {
  /// See also [getP3].
  GetP3Provider(
    String vnId,
  ) : this._internal(
          (ref) => getP3(
            ref as GetP3Ref,
            vnId,
          ),
          from: getP3Provider,
          name: r'getP3Provider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getP3Hash,
          dependencies: GetP3Family._dependencies,
          allTransitiveDependencies: GetP3Family._allTransitiveDependencies,
          vnId: vnId,
        );

  GetP3Provider._internal(
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
    FutureOr<VnDataPhase03?> Function(GetP3Ref provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetP3Provider._internal(
        (ref) => create(ref as GetP3Ref),
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
  AutoDisposeFutureProviderElement<VnDataPhase03?> createElement() {
    return _GetP3ProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetP3Provider && other.vnId == vnId;
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
mixin GetP3Ref on AutoDisposeFutureProviderRef<VnDataPhase03?> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _GetP3ProviderElement
    extends AutoDisposeFutureProviderElement<VnDataPhase03?> with GetP3Ref {
  _GetP3ProviderElement(super.provider);

  @override
  String get vnId => (origin as GetP3Provider).vnId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
