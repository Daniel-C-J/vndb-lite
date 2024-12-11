// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vn_detail_fab_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vnDetailFabStateHash() => r'80a13002cd24b41a198c7d7a6ecb1f5871221a78';

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

abstract class _$VnDetailFabState extends BuildlessAutoDisposeNotifier<bool> {
  late final String vnId;

  bool build(
    String vnId,
  );
}

/// See also [VnDetailFabState].
@ProviderFor(VnDetailFabState)
const vnDetailFabStateProvider = VnDetailFabStateFamily();

/// See also [VnDetailFabState].
class VnDetailFabStateFamily extends Family<bool> {
  /// See also [VnDetailFabState].
  const VnDetailFabStateFamily();

  /// See also [VnDetailFabState].
  VnDetailFabStateProvider call(
    String vnId,
  ) {
    return VnDetailFabStateProvider(
      vnId,
    );
  }

  @override
  VnDetailFabStateProvider getProviderOverride(
    covariant VnDetailFabStateProvider provider,
  ) {
    return call(
      provider.vnId,
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
  String? get name => r'vnDetailFabStateProvider';
}

/// See also [VnDetailFabState].
class VnDetailFabStateProvider
    extends AutoDisposeNotifierProviderImpl<VnDetailFabState, bool> {
  /// See also [VnDetailFabState].
  VnDetailFabStateProvider(
    String vnId,
  ) : this._internal(
          () => VnDetailFabState()..vnId = vnId,
          from: vnDetailFabStateProvider,
          name: r'vnDetailFabStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vnDetailFabStateHash,
          dependencies: VnDetailFabStateFamily._dependencies,
          allTransitiveDependencies:
              VnDetailFabStateFamily._allTransitiveDependencies,
          vnId: vnId,
        );

  VnDetailFabStateProvider._internal(
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
  bool runNotifierBuild(
    covariant VnDetailFabState notifier,
  ) {
    return notifier.build(
      vnId,
    );
  }

  @override
  Override overrideWith(VnDetailFabState Function() create) {
    return ProviderOverride(
      origin: this,
      override: VnDetailFabStateProvider._internal(
        () => create()..vnId = vnId,
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
  AutoDisposeNotifierProviderElement<VnDetailFabState, bool> createElement() {
    return _VnDetailFabStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VnDetailFabStateProvider && other.vnId == vnId;
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
mixin VnDetailFabStateRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _VnDetailFabStateProviderElement
    extends AutoDisposeNotifierProviderElement<VnDetailFabState, bool>
    with VnDetailFabStateRef {
  _VnDetailFabStateProviderElement(super.provider);

  @override
  String get vnId => (origin as VnDetailFabStateProvider).vnId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
