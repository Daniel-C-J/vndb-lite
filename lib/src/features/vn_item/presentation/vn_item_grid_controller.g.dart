// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vn_item_grid_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vnItemGridCoverCensorStateHash() =>
    r'36e4354f6c78098a9044491c614b837522a083cb';

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

abstract class _$VnItemGridCoverCensorState extends BuildlessNotifier<bool> {
  late final String vnId;

  bool build(
    String vnId,
  );
}

/// See also [VnItemGridCoverCensorState].
@ProviderFor(VnItemGridCoverCensorState)
const vnItemGridCoverCensorStateProvider = VnItemGridCoverCensorStateFamily();

/// See also [VnItemGridCoverCensorState].
class VnItemGridCoverCensorStateFamily extends Family<bool> {
  /// See also [VnItemGridCoverCensorState].
  const VnItemGridCoverCensorStateFamily();

  /// See also [VnItemGridCoverCensorState].
  VnItemGridCoverCensorStateProvider call(
    String vnId,
  ) {
    return VnItemGridCoverCensorStateProvider(
      vnId,
    );
  }

  @override
  VnItemGridCoverCensorStateProvider getProviderOverride(
    covariant VnItemGridCoverCensorStateProvider provider,
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
  String? get name => r'vnItemGridCoverCensorStateProvider';
}

/// See also [VnItemGridCoverCensorState].
class VnItemGridCoverCensorStateProvider
    extends NotifierProviderImpl<VnItemGridCoverCensorState, bool> {
  /// See also [VnItemGridCoverCensorState].
  VnItemGridCoverCensorStateProvider(
    String vnId,
  ) : this._internal(
          () => VnItemGridCoverCensorState()..vnId = vnId,
          from: vnItemGridCoverCensorStateProvider,
          name: r'vnItemGridCoverCensorStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vnItemGridCoverCensorStateHash,
          dependencies: VnItemGridCoverCensorStateFamily._dependencies,
          allTransitiveDependencies:
              VnItemGridCoverCensorStateFamily._allTransitiveDependencies,
          vnId: vnId,
        );

  VnItemGridCoverCensorStateProvider._internal(
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
    covariant VnItemGridCoverCensorState notifier,
  ) {
    return notifier.build(
      vnId,
    );
  }

  @override
  Override overrideWith(VnItemGridCoverCensorState Function() create) {
    return ProviderOverride(
      origin: this,
      override: VnItemGridCoverCensorStateProvider._internal(
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
  NotifierProviderElement<VnItemGridCoverCensorState, bool> createElement() {
    return _VnItemGridCoverCensorStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VnItemGridCoverCensorStateProvider && other.vnId == vnId;
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
mixin VnItemGridCoverCensorStateRef on NotifierProviderRef<bool> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _VnItemGridCoverCensorStateProviderElement
    extends NotifierProviderElement<VnItemGridCoverCensorState, bool>
    with VnItemGridCoverCensorStateRef {
  _VnItemGridCoverCensorStateProviderElement(super.provider);

  @override
  String get vnId => (origin as VnItemGridCoverCensorStateProvider).vnId;
}

String _$vnItemGridCoverSizeStateHash() =>
    r'c2abf516fb05867b03e74b9fd57b2afec0673741';

abstract class _$VnItemGridCoverSizeState extends BuildlessNotifier<double> {
  late final String vnUrl;

  double build(
    String vnUrl,
  );
}

/// See also [VnItemGridCoverSizeState].
@ProviderFor(VnItemGridCoverSizeState)
const vnItemGridCoverSizeStateProvider = VnItemGridCoverSizeStateFamily();

/// See also [VnItemGridCoverSizeState].
class VnItemGridCoverSizeStateFamily extends Family<double> {
  /// See also [VnItemGridCoverSizeState].
  const VnItemGridCoverSizeStateFamily();

  /// See also [VnItemGridCoverSizeState].
  VnItemGridCoverSizeStateProvider call(
    String vnUrl,
  ) {
    return VnItemGridCoverSizeStateProvider(
      vnUrl,
    );
  }

  @override
  VnItemGridCoverSizeStateProvider getProviderOverride(
    covariant VnItemGridCoverSizeStateProvider provider,
  ) {
    return call(
      provider.vnUrl,
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
  String? get name => r'vnItemGridCoverSizeStateProvider';
}

/// See also [VnItemGridCoverSizeState].
class VnItemGridCoverSizeStateProvider
    extends NotifierProviderImpl<VnItemGridCoverSizeState, double> {
  /// See also [VnItemGridCoverSizeState].
  VnItemGridCoverSizeStateProvider(
    String vnUrl,
  ) : this._internal(
          () => VnItemGridCoverSizeState()..vnUrl = vnUrl,
          from: vnItemGridCoverSizeStateProvider,
          name: r'vnItemGridCoverSizeStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vnItemGridCoverSizeStateHash,
          dependencies: VnItemGridCoverSizeStateFamily._dependencies,
          allTransitiveDependencies:
              VnItemGridCoverSizeStateFamily._allTransitiveDependencies,
          vnUrl: vnUrl,
        );

  VnItemGridCoverSizeStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vnUrl,
  }) : super.internal();

  final String vnUrl;

  @override
  double runNotifierBuild(
    covariant VnItemGridCoverSizeState notifier,
  ) {
    return notifier.build(
      vnUrl,
    );
  }

  @override
  Override overrideWith(VnItemGridCoverSizeState Function() create) {
    return ProviderOverride(
      origin: this,
      override: VnItemGridCoverSizeStateProvider._internal(
        () => create()..vnUrl = vnUrl,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vnUrl: vnUrl,
      ),
    );
  }

  @override
  NotifierProviderElement<VnItemGridCoverSizeState, double> createElement() {
    return _VnItemGridCoverSizeStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VnItemGridCoverSizeStateProvider && other.vnUrl == vnUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vnUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VnItemGridCoverSizeStateRef on NotifierProviderRef<double> {
  /// The parameter `vnUrl` of this provider.
  String get vnUrl;
}

class _VnItemGridCoverSizeStateProviderElement
    extends NotifierProviderElement<VnItemGridCoverSizeState, double>
    with VnItemGridCoverSizeStateRef {
  _VnItemGridCoverSizeStateProviderElement(super.provider);

  @override
  String get vnUrl => (origin as VnItemGridCoverSizeStateProvider).vnUrl;
}

String _$vnItemGridWidgetStateHash() =>
    r'883194a37b3df6587ab69f76f66a5aa2ed4afb77';

abstract class _$VnItemGridWidgetState extends BuildlessNotifier<bool> {
  late final String vnId;

  bool build(
    String vnId,
  );
}

/// See also [VnItemGridWidgetState].
@ProviderFor(VnItemGridWidgetState)
const vnItemGridWidgetStateProvider = VnItemGridWidgetStateFamily();

/// See also [VnItemGridWidgetState].
class VnItemGridWidgetStateFamily extends Family<bool> {
  /// See also [VnItemGridWidgetState].
  const VnItemGridWidgetStateFamily();

  /// See also [VnItemGridWidgetState].
  VnItemGridWidgetStateProvider call(
    String vnId,
  ) {
    return VnItemGridWidgetStateProvider(
      vnId,
    );
  }

  @override
  VnItemGridWidgetStateProvider getProviderOverride(
    covariant VnItemGridWidgetStateProvider provider,
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
  String? get name => r'vnItemGridWidgetStateProvider';
}

/// See also [VnItemGridWidgetState].
class VnItemGridWidgetStateProvider
    extends NotifierProviderImpl<VnItemGridWidgetState, bool> {
  /// See also [VnItemGridWidgetState].
  VnItemGridWidgetStateProvider(
    String vnId,
  ) : this._internal(
          () => VnItemGridWidgetState()..vnId = vnId,
          from: vnItemGridWidgetStateProvider,
          name: r'vnItemGridWidgetStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vnItemGridWidgetStateHash,
          dependencies: VnItemGridWidgetStateFamily._dependencies,
          allTransitiveDependencies:
              VnItemGridWidgetStateFamily._allTransitiveDependencies,
          vnId: vnId,
        );

  VnItemGridWidgetStateProvider._internal(
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
    covariant VnItemGridWidgetState notifier,
  ) {
    return notifier.build(
      vnId,
    );
  }

  @override
  Override overrideWith(VnItemGridWidgetState Function() create) {
    return ProviderOverride(
      origin: this,
      override: VnItemGridWidgetStateProvider._internal(
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
  NotifierProviderElement<VnItemGridWidgetState, bool> createElement() {
    return _VnItemGridWidgetStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VnItemGridWidgetStateProvider && other.vnId == vnId;
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
mixin VnItemGridWidgetStateRef on NotifierProviderRef<bool> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _VnItemGridWidgetStateProviderElement
    extends NotifierProviderElement<VnItemGridWidgetState, bool>
    with VnItemGridWidgetStateRef {
  _VnItemGridWidgetStateProviderElement(super.provider);

  @override
  String get vnId => (origin as VnItemGridWidgetStateProvider).vnId;
}

String _$vnItemGridAlmostLongPressedStateHash() =>
    r'ef6b02aad8cf723f61e558cb42897b593b5209f2';

/// See also [VnItemGridAlmostLongPressedState].
@ProviderFor(VnItemGridAlmostLongPressedState)
final vnItemGridAlmostLongPressedStateProvider = AutoDisposeNotifierProvider<
    VnItemGridAlmostLongPressedState, String>.internal(
  VnItemGridAlmostLongPressedState.new,
  name: r'vnItemGridAlmostLongPressedStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vnItemGridAlmostLongPressedStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VnItemGridAlmostLongPressedState = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
