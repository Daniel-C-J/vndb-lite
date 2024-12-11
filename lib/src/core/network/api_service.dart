import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vndb_lite/src/constants/conf.dart';
import 'package:vndb_lite/src/core/network/dio_factory.dart';
import 'network_error_handler.dart';
import 'network_helper.dart';

part 'api_service.g.dart';

class ApiService {
  final Dio _dio;
  final NetworkInfo _networkInfo;

  ApiService(this._dio, this._networkInfo) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        // onError: _onError,
      ),
    );
  }

  _onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final isConnected = await _networkInfo.isConnected;

    if (isConnected) {
      return handler.next(options);
    }

    return handler.reject(
      DioException(
        requestOptions: options,
        response: Response(
          requestOptions: options,
          statusCode: ResponseCode.noInternetConnection,
          statusMessage: ResponseMessage.noInternetConnection,
        ),
        error: ResponseMessage.noInternetConnection,
        type: DioExceptionType.connectionTimeout,
      ),
    );
  }

  Future<Response> get(
      {required String endPoint, dynamic data, dynamic params, dynamic options, dynamic cancelToken}) async {
    var response = await _dio.get(
      '${Default.BASE_URL}$endPoint',
      data: data,
      options: options,
      queryParameters: params,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> post(
      {required String endPoint, dynamic data, dynamic params, dynamic options, dynamic cancelToken}) async {
    var response = await _dio.post(
      '${Default.BASE_URL}$endPoint',
      data: data,
      options: options,
      queryParameters: params,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> put({required String endPoint, dynamic options, dynamic cancelToken}) async {
    var response = await _dio.put(
      '${Default.BASE_URL}$endPoint',
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> patch(
      {required String endPoint, dynamic data, dynamic options, dynamic cancelToken}) async {
    var response = await _dio.patch(
      '${Default.BASE_URL}$endPoint',
      data: data,
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> delete({required String endPoint, dynamic options, dynamic cancelToken}) async {
    var response = await _dio.delete(
      '${Default.BASE_URL}$endPoint',
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }
}

// TODO Create an abstract repo for the remote datasource,
// Check reference repository_impl.dart from clean-architecture
// One that implements the network ErrorHandler class.
// Cannot do directly here, it will violate single responsibility.
// Must have another class, should be repo, that sends request to the data source,
// then another class a controller that determine whether the result is an error or success,
// e.g
// try{
//   final response = apiService.get(request);
//   return ModelClass(response); // <- domain then to presentation (optional)
// }catch(error){
//   return ErrorHandler.handle(error).failure; <- domain then to presentation (optional)
// ^This will led to GenericFailureMessage
// }

@riverpod
ApiService apiService(Ref ref) {
  final dio = ref.watch(dioFactoryProvider).getDio();
  final networkInfo = ref.watch(networkInfoProvider);
  return ApiService(dio, networkInfo);
}
