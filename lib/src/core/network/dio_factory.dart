import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';

part 'dio_factory.g.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String authorization = "Authorization";
const String accept = "accept";
const int apiTimeOut = 60000;

final Map<String, String> dioHeaders = {
  contentType: applicationJson,
  accept: applicationJson,
};

class DioFactory {
  Dio getDio() {
    final Dio dio = Dio();

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
        client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
        return client;
      },
    );

    dio.options = BaseOptions(
      baseUrl: Default.BASE_URL,
      headers: dioHeaders,
      contentType: applicationJson,
      receiveTimeout: const Duration(milliseconds: apiTimeOut),
      sendTimeout: const Duration(milliseconds: apiTimeOut),
      connectTimeout: const Duration(milliseconds: apiTimeOut),
    );

    if (!kReleaseMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    return dio;
  }
}

@riverpod
DioFactory dioFactory(Ref ref) {
  return DioFactory();
}
