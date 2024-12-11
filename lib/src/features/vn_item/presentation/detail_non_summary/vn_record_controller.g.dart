// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vn_record_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vnRecordControllerHash() =>
    r'0fbf8c97aae00643a37f033f7198f91ee2c3dac6';

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

abstract class _$VnRecordController extends BuildlessNotifier<VnRecord?> {
  late final String vnId;

  VnRecord? build(
    String vnId,
  );
}

/// See also [VnRecordController].
@ProviderFor(VnRecordController)
const vnRecordControllerProvider = VnRecordControllerFamily();

/// See also [VnRecordController].
class VnRecordControllerFamily extends Family<VnRecord?> {
  /// See also [VnRecordController].
  const VnRecordControllerFamily();

  /// See also [VnRecordController].
  VnRecordControllerProvider call(
    String vnId,
  ) {
    return VnRecordControllerProvider(
      vnId,
    );
  }

  @override
  VnRecordControllerProvider getProviderOverride(
    covariant VnRecordControllerProvider provider,
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
  String? get name => r'vnRecordControllerProvider';
}

/// See also [VnRecordController].
class VnRecordControllerProvider
    extends NotifierProviderImpl<VnRecordController, VnRecord?> {
  /// See also [VnRecordController].
  VnRecordControllerProvider(
    String vnId,
  ) : this._internal(
          () => VnRecordController()..vnId = vnId,
          from: vnRecordControllerProvider,
          name: r'vnRecordControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$vnRecordControllerHash,
          dependencies: VnRecordControllerFamily._dependencies,
          allTransitiveDependencies:
              VnRecordControllerFamily._allTransitiveDependencies,
          vnId: vnId,
        );

  VnRecordControllerProvider._internal(
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
  VnRecord? runNotifierBuild(
    covariant VnRecordController notifier,
  ) {
    return notifier.build(
      vnId,
    );
  }

  @override
  Override overrideWith(VnRecordController Function() create) {
    return ProviderOverride(
      origin: this,
      override: VnRecordControllerProvider._internal(
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
  NotifierProviderElement<VnRecordController, VnRecord?> createElement() {
    return _VnRecordControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VnRecordControllerProvider && other.vnId == vnId;
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
mixin VnRecordControllerRef on NotifierProviderRef<VnRecord?> {
  /// The parameter `vnId` of this provider.
  String get vnId;
}

class _VnRecordControllerProviderElement
    extends NotifierProviderElement<VnRecordController, VnRecord?>
    with VnRecordControllerRef {
  _VnRecordControllerProviderElement(super.provider);

  @override
  String get vnId => (origin as VnRecordControllerProvider).vnId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
