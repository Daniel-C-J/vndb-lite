// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_vn_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$validateVnAndSaveToLocalHash() =>
    r'9e5318eeec32518e7553e446a4de57da66008d5e';

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

/// See also [validateVnAndSaveToLocal].
@ProviderFor(validateVnAndSaveToLocal)
const validateVnAndSaveToLocalProvider = ValidateVnAndSaveToLocalFamily();

/// See also [validateVnAndSaveToLocal].
class ValidateVnAndSaveToLocalFamily extends Family<AsyncValue<bool>> {
  /// See also [validateVnAndSaveToLocal].
  const ValidateVnAndSaveToLocalFamily();

  /// See also [validateVnAndSaveToLocal].
  ValidateVnAndSaveToLocalProvider call(
    String vnId,
  ) {
    return ValidateVnAndSaveToLocalProvider(
      vnId,
    );
  }

  @override
  ValidateVnAndSaveToLocalProvider getProviderOverride(
    covariant ValidateVnAndSaveToLocalProvider provider,
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
  String? get name => r'validateVnAndSaveToLocalProvider';
}

/// See also [validateVnAndSaveToLocal].
class ValidateVnAndSaveToLocalProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [validateVnAndSaveToLocal].
  ValidateVnAndSaveToLocalProvider(
    String vnId,
  ) : this._internal(
          (ref) => validateVnAndSaveToLocal(
            ref as ValidateVnAndSaveToLocalRef,
            vnId,
          ),
          from: validateVnAndSaveToLocalProvider,
          name: r'validateVnAndSaveToLocalProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$validateVnAndSaveToLocalHash,
          dependencies: ValidateVnAndSaveToLocalFamily._dependencies,
          allTransitiveDependencies:
              ValidateVnAndSaveToLocalFamily._allTransitiveDependencies,
          vnId: vnId,
        );

  ValidateVnAndSaveToLocalProvider._internal(
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
    FutureOr<bool> Function(ValidateVnAndSaveToLocalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ValidateVnAndSaveToLocalProvider._internal(
        (ref) => create(ref as ValidateVnAndSaveToLocalRef),
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
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _ValidateVnAndSaveToLocalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidateVnAndSaveToLocalProvider && other.vnId == vnId;
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
mixin ValidateVnAndSaveToLocalRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _ValidateVnAndSaveToLocalProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with ValidateVnAndSaveToLocalRef {
  _ValidateVnAndSaveToLocalProviderElement(super.provider);

  @override
  String get vnId => (origin as ValidateVnAndSaveToLocalProvider).vnId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
