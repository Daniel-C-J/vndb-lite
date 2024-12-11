import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_helper.g.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  NetworkInfoImpl(this._internetConnectionChecker);

  final InternetConnection _internetConnectionChecker;

  @override
  Future<bool> get isConnected => _internetConnectionChecker.hasInternetAccess;
}

@riverpod
NetworkInfoImpl networkInfo(Ref ref) {
  return NetworkInfoImpl(InternetConnection());
}
