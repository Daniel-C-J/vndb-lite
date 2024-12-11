// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncServiceHash() => r'99fb48aa249169a7302c0af8d5e607b5b0e4db39';

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

/// See also [syncService].
@ProviderFor(syncService)
const syncServiceProvider = SyncServiceFamily();

/// See also [syncService].
class SyncServiceFamily extends Family<SyncService> {
  /// See also [syncService].
  const SyncServiceFamily();

  /// See also [syncService].
  SyncServiceProvider call({
    required void Function(String,
            {required IconData icon, required Color iconColor})
        snackbar,
  }) {
    return SyncServiceProvider(
      snackbar: snackbar,
    );
  }

  @override
  SyncServiceProvider getProviderOverride(
    covariant SyncServiceProvider provider,
  ) {
    return call(
      snackbar: provider.snackbar,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'syncServiceProvider';
}

/// See also [syncService].
class SyncServiceProvider extends AutoDisposeProvider<SyncService> {
  /// See also [syncService].
  SyncServiceProvider({
    required void Function(String,
            {required IconData icon, required Color iconColor})
        snackbar,
  }) : this._internal(
          (ref) => syncService(
            ref as SyncServiceRef,
            snackbar: snackbar,
          ),
          from: syncServiceProvider,
          name: r'syncServiceProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$syncServiceHash,
          dependencies: SyncServiceFamily._dependencies,
          allTransitiveDependencies:
              SyncServiceFamily._allTransitiveDependencies,
          snackbar: snackbar,
        );

  SyncServiceProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.snackbar,
  }) : super.internal();

  final void Function(String,
      {required IconData icon, required Color iconColor}) snackbar;

  @override
  Override overrideWith(
    SyncService Function(SyncServiceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SyncServiceProvider._internal(
        (ref) => create(ref as SyncServiceRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        snackbar: snackbar,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<SyncService> createElement() {
    return _SyncServiceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SyncServiceProvider && other.snackbar == snackbar;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, snackbar.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SyncServiceRef on AutoDisposeProviderRef<SyncService> {
  /// The parameter `snackbar` of this provider.
  void Function(String, {required IconData icon, required Color iconColor})
      get snackbar;
}

class _SyncServiceProviderElement
    extends AutoDisposeProviderElement<SyncService> with SyncServiceRef {
  _SyncServiceProviderElement(super.provider);

  @override
  void Function(String, {required IconData icon, required Color iconColor})
      get snackbar => (origin as SyncServiceProvider).snackbar;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
