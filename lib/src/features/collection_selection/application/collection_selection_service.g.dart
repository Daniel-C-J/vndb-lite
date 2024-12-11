// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_selection_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$vnSelectionServiceHash() =>
    r'3893142bc62e10864be15fa95ee1dd10e89414ad';

/// See also [vnSelectionService].
@ProviderFor(vnSelectionService)
final vnSelectionServiceProvider =
    AutoDisposeProvider<VnSelectionService>.internal(
  vnSelectionService,
  name: r'vnSelectionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$vnSelectionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VnSelectionServiceRef = AutoDisposeProviderRef<VnSelectionService>;
String _$confirmSelectionHash() => r'7f8bcf81337ecd7c912a97ebef20d7af823b541d';

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

/// See also [confirmSelection].
@ProviderFor(confirmSelection)
const confirmSelectionProvider = ConfirmSelectionFamily();

/// See also [confirmSelection].
class ConfirmSelectionFamily extends Family<AsyncValue<void>> {
  /// See also [confirmSelection].
  const ConfirmSelectionFamily();

  /// See also [confirmSelection].
  ConfirmSelectionProvider call({
    required List<VnDataPhase01> p1List,
    required Map<String, VnRecord?> vnRecords,
    required VnSelection selection,
    required void Function() whenSuccess,
    required dynamic Function(Object, StackTrace) whenErr,
    required void Function(String) saveRefresh,
  }) {
    return ConfirmSelectionProvider(
      p1List: p1List,
      vnRecords: vnRecords,
      selection: selection,
      whenSuccess: whenSuccess,
      whenErr: whenErr,
      saveRefresh: saveRefresh,
    );
  }

  @override
  ConfirmSelectionProvider getProviderOverride(
    covariant ConfirmSelectionProvider provider,
  ) {
    return call(
      p1List: provider.p1List,
      vnRecords: provider.vnRecords,
      selection: provider.selection,
      whenSuccess: provider.whenSuccess,
      whenErr: provider.whenErr,
      saveRefresh: provider.saveRefresh,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    vnSelectionServiceProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    vnSelectionServiceProvider,
    ...?vnSelectionServiceProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'confirmSelectionProvider';
}

/// See also [confirmSelection].
class ConfirmSelectionProvider extends AutoDisposeFutureProvider<void> {
  /// See also [confirmSelection].
  ConfirmSelectionProvider({
    required List<VnDataPhase01> p1List,
    required Map<String, VnRecord?> vnRecords,
    required VnSelection selection,
    required void Function() whenSuccess,
    required dynamic Function(Object, StackTrace) whenErr,
    required void Function(String) saveRefresh,
  }) : this._internal(
          (ref) => confirmSelection(
            ref as ConfirmSelectionRef,
            p1List: p1List,
            vnRecords: vnRecords,
            selection: selection,
            whenSuccess: whenSuccess,
            whenErr: whenErr,
            saveRefresh: saveRefresh,
          ),
          from: confirmSelectionProvider,
          name: r'confirmSelectionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$confirmSelectionHash,
          dependencies: ConfirmSelectionFamily._dependencies,
          allTransitiveDependencies:
              ConfirmSelectionFamily._allTransitiveDependencies,
          p1List: p1List,
          vnRecords: vnRecords,
          selection: selection,
          whenSuccess: whenSuccess,
          whenErr: whenErr,
          saveRefresh: saveRefresh,
        );

  ConfirmSelectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.p1List,
    required this.vnRecords,
    required this.selection,
    required this.whenSuccess,
    required this.whenErr,
    required this.saveRefresh,
  }) : super.internal();

  final List<VnDataPhase01> p1List;
  final Map<String, VnRecord?> vnRecords;
  final VnSelection selection;
  final void Function() whenSuccess;
  final dynamic Function(Object, StackTrace) whenErr;
  final void Function(String) saveRefresh;

  @override
  Override overrideWith(
    FutureOr<void> Function(ConfirmSelectionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConfirmSelectionProvider._internal(
        (ref) => create(ref as ConfirmSelectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        p1List: p1List,
        vnRecords: vnRecords,
        selection: selection,
        whenSuccess: whenSuccess,
        whenErr: whenErr,
        saveRefresh: saveRefresh,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _ConfirmSelectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConfirmSelectionProvider &&
        other.p1List == p1List &&
        other.vnRecords == vnRecords &&
        other.selection == selection &&
        other.whenSuccess == whenSuccess &&
        other.whenErr == whenErr &&
        other.saveRefresh == saveRefresh;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, p1List.hashCode);
    hash = _SystemHash.combine(hash, vnRecords.hashCode);
    hash = _SystemHash.combine(hash, selection.hashCode);
    hash = _SystemHash.combine(hash, whenSuccess.hashCode);
    hash = _SystemHash.combine(hash, whenErr.hashCode);
    hash = _SystemHash.combine(hash, saveRefresh.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ConfirmSelectionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `p1List` of this provider.
  List<VnDataPhase01> get p1List;

  /// The parameter `vnRecords` of this provider.
  Map<String, VnRecord?> get vnRecords;

  /// The parameter `selection` of this provider.
  VnSelection get selection;

  /// The parameter `whenSuccess` of this provider.
  void Function() get whenSuccess;

  /// The parameter `whenErr` of this provider.
  dynamic Function(Object, StackTrace) get whenErr;

  /// The parameter `saveRefresh` of this provider.
  void Function(String) get saveRefresh;
}

class _ConfirmSelectionProviderElement
    extends AutoDisposeFutureProviderElement<void> with ConfirmSelectionRef {
  _ConfirmSelectionProviderElement(super.provider);

  @override
  List<VnDataPhase01> get p1List => (origin as ConfirmSelectionProvider).p1List;
  @override
  Map<String, VnRecord?> get vnRecords =>
      (origin as ConfirmSelectionProvider).vnRecords;
  @override
  VnSelection get selection => (origin as ConfirmSelectionProvider).selection;
  @override
  void Function() get whenSuccess =>
      (origin as ConfirmSelectionProvider).whenSuccess;
  @override
  dynamic Function(Object, StackTrace) get whenErr =>
      (origin as ConfirmSelectionProvider).whenErr;
  @override
  void Function(String) get saveRefresh =>
      (origin as ConfirmSelectionProvider).saveRefresh;
}

String _$removeSelectionHash() => r'47fb3fef49d033507061f7e220d9b17ebb20b0dd';

/// See also [removeSelection].
@ProviderFor(removeSelection)
const removeSelectionProvider = RemoveSelectionFamily();

/// See also [removeSelection].
class RemoveSelectionFamily extends Family<AsyncValue<void>> {
  /// See also [removeSelection].
  const RemoveSelectionFamily();

  /// See also [removeSelection].
  RemoveSelectionProvider call(
    List<VnRecord?> vnRecords, {
    required void Function() whenSuccess,
    required void Function(String) removeRefresh,
  }) {
    return RemoveSelectionProvider(
      vnRecords,
      whenSuccess: whenSuccess,
      removeRefresh: removeRefresh,
    );
  }

  @override
  RemoveSelectionProvider getProviderOverride(
    covariant RemoveSelectionProvider provider,
  ) {
    return call(
      provider.vnRecords,
      whenSuccess: provider.whenSuccess,
      removeRefresh: provider.removeRefresh,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    vnSelectionServiceProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    vnSelectionServiceProvider,
    ...?vnSelectionServiceProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'removeSelectionProvider';
}

/// See also [removeSelection].
class RemoveSelectionProvider extends AutoDisposeFutureProvider<void> {
  /// See also [removeSelection].
  RemoveSelectionProvider(
    List<VnRecord?> vnRecords, {
    required void Function() whenSuccess,
    required void Function(String) removeRefresh,
  }) : this._internal(
          (ref) => removeSelection(
            ref as RemoveSelectionRef,
            vnRecords,
            whenSuccess: whenSuccess,
            removeRefresh: removeRefresh,
          ),
          from: removeSelectionProvider,
          name: r'removeSelectionProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$removeSelectionHash,
          dependencies: RemoveSelectionFamily._dependencies,
          allTransitiveDependencies:
              RemoveSelectionFamily._allTransitiveDependencies,
          vnRecords: vnRecords,
          whenSuccess: whenSuccess,
          removeRefresh: removeRefresh,
        );

  RemoveSelectionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.vnRecords,
    required this.whenSuccess,
    required this.removeRefresh,
  }) : super.internal();

  final List<VnRecord?> vnRecords;
  final void Function() whenSuccess;
  final void Function(String) removeRefresh;

  @override
  Override overrideWith(
    FutureOr<void> Function(RemoveSelectionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RemoveSelectionProvider._internal(
        (ref) => create(ref as RemoveSelectionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        vnRecords: vnRecords,
        whenSuccess: whenSuccess,
        removeRefresh: removeRefresh,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _RemoveSelectionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RemoveSelectionProvider &&
        other.vnRecords == vnRecords &&
        other.whenSuccess == whenSuccess &&
        other.removeRefresh == removeRefresh;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, vnRecords.hashCode);
    hash = _SystemHash.combine(hash, whenSuccess.hashCode);
    hash = _SystemHash.combine(hash, removeRefresh.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RemoveSelectionRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `vnRecords` of this provider.
  List<VnRecord?> get vnRecords;

  /// The parameter `whenSuccess` of this provider.
  void Function() get whenSuccess;

  /// The parameter `removeRefresh` of this provider.
  void Function(String) get removeRefresh;
}

class _RemoveSelectionProviderElement
    extends AutoDisposeFutureProviderElement<void> with RemoveSelectionRef {
  _RemoveSelectionProviderElement(super.provider);

  @override
  List<VnRecord?> get vnRecords =>
      (origin as RemoveSelectionProvider).vnRecords;
  @override
  void Function() get whenSuccess =>
      (origin as RemoveSelectionProvider).whenSuccess;
  @override
  void Function(String) get removeRefresh =>
      (origin as RemoveSelectionProvider).removeRefresh;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
