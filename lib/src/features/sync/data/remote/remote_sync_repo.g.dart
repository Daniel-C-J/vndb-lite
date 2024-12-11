// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_sync_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$remoteSyncRepoHash() => r'3e07dbf1dcbe53a2e47638e191989ac6f819059e';

/// See also [remoteSyncRepo].
@ProviderFor(remoteSyncRepo)
final remoteSyncRepoProvider = AutoDisposeProvider<RemoteSyncRepo>.internal(
  remoteSyncRepo,
  name: r'remoteSyncRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$remoteSyncRepoHash,
  dependencies: <ProviderOrFamily>[
    apiServiceProvider,
    localCollectionRepoProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    apiServiceProvider,
    ...?apiServiceProvider.allTransitiveDependencies,
    localCollectionRepoProvider,
    ...?localCollectionRepoProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RemoteSyncRepoRef = AutoDisposeProviderRef<RemoteSyncRepo>;
String _$authenticateHash() => r'b1589d29665648dfd168166fddd6e2b75f505b9e';

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

/// See also [authenticate].
@ProviderFor(authenticate)
const authenticateProvider = AuthenticateFamily();

/// See also [authenticate].
class AuthenticateFamily extends Family<AsyncValue<Response>> {
  /// See also [authenticate].
  const AuthenticateFamily();

  /// See also [authenticate].
  AuthenticateProvider call(
    String token,
  ) {
    return AuthenticateProvider(
      token,
    );
  }

  @override
  AuthenticateProvider getProviderOverride(
    covariant AuthenticateProvider provider,
  ) {
    return call(
      provider.token,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    remoteSyncRepoProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    remoteSyncRepoProvider,
    ...?remoteSyncRepoProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'authenticateProvider';
}

/// See also [authenticate].
class AuthenticateProvider extends AutoDisposeFutureProvider<Response> {
  /// See also [authenticate].
  AuthenticateProvider(
    String token,
  ) : this._internal(
          (ref) => authenticate(
            ref as AuthenticateRef,
            token,
          ),
          from: authenticateProvider,
          name: r'authenticateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$authenticateHash,
          dependencies: AuthenticateFamily._dependencies,
          allTransitiveDependencies:
              AuthenticateFamily._allTransitiveDependencies,
          token: token,
        );

  AuthenticateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
  }) : super.internal();

  final String token;

  @override
  Override overrideWith(
    FutureOr<Response> Function(AuthenticateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AuthenticateProvider._internal(
        (ref) => create(ref as AuthenticateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Response> createElement() {
    return _AuthenticateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuthenticateProvider && other.token == token;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuthenticateRef on AutoDisposeFutureProviderRef<Response> {
  /// The parameter `token` of this provider.
  String get token;
}

class _AuthenticateProviderElement
    extends AutoDisposeFutureProviderElement<Response> with AuthenticateRef {
  _AuthenticateProviderElement(super.provider);

  @override
  String get token => (origin as AuthenticateProvider).token;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
