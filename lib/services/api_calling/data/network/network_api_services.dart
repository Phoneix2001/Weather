import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:weather/services/api_calling/data/network/base_api_services.dart';

import '../../../../utils/functions/logs.dart';
import '../app_exception.dart';

class NetworkApiService extends BaseApiServices {
  final _dio = Dio();
  NetworkApiService._();
  static final NetworkApiService _instance = NetworkApiService._();

  static NetworkApiService get instance => _instance;

  // Centralized request performer
  Future<Response?> _performRequest(
    Future<Response> Function() requestFn,
  ) async {
    try {
      return await requestFn().timeout(const Duration(minutes: 10));
    } on DioException catch (e) {
      return _handleDioError(e);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    }
  }

  // Centralized Dio error handling
  Response? _handleDioError(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      throw CancelException(jsonEncode({"message": "Request canceled"}));
    }

    final isConnectionError =
        e.type == DioExceptionType.connectionError ||
        e.error.toString().startsWith("HandshakeException");

    if (isConnectionError) {
      throw NoInternetException('No Internet Connection');
    }

    return e.response;
  }

  // Centralized header builder
  Map<String, String> _buildHeaders({
    String? token,
    Map<String, String>? header,
  }) {
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (header != null) headers.addAll(header);
    return headers;
  }

  void _logRequest(String method, String url, {dynamic data}) {
    logI("$method Request", url);
    if (data != null) logI("Payload", data.toString());
  }

  dynamic _handleResponse(Response? response) {
    if (response == null) throw FetchDataException("Null response");
    return returnResponseError(response);
  }

  // Basic POST request
  @override
  Future postResponse(
    String url,
    dynamic data, {
    CancelToken? cancelToken,
  }) async {
    _logRequest("POST", url, data: data);
    final response = await _performRequest(
      () => _dio.post(
        url,
        data: jsonEncode(data),
        options: Options(headers: _buildHeaders()),
        cancelToken: cancelToken,
      ),
    );
    return _handleResponse(response);
  }

  // Custom status code handling (refactor this as needed)
  dynamic returnResponseError(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data);
      case 401:
      case 403:
        throw UnauthorisedException(response.data);
      case 404:
        throw PageNotFoundException(response.data);
      case 500:
      default:
        throw FetchDataException(response.data);
    }
  }

  @override
  Future getResponse(
    String url, {
    String? token,
    CancelToken? cancelToken,
  }) async {
    _logRequest("GET", url);
    final response = await _performRequest(() => _dio.get(url));
    return _handleResponse(response);
  }

  @override
  Future postHeaderWithoutBodyResponse(
    String url,
    String token, {
    CancelToken? cancelToken,
    String? refreshToken,
  }) async {
    _logRequest("POST", url);
    final response = await _performRequest(
      () => _dio.post(
        url,
        options: Options(headers: _buildHeaders(token: token)),
        cancelToken: cancelToken,
      ),
    );
    return _handleResponse(response);
  }
}
