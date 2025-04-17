import 'package:dio/dio.dart';

abstract class BaseApiServices {
  Future<dynamic> getResponse(String url,
      {String? token, CancelToken? cancelToken});
  Future<dynamic> postResponse(String url, dynamic data,{CancelToken? cancelToken});
  Future<dynamic> postHeaderWithoutBodyResponse(String url, String token,{CancelToken? cancelToken,String? refreshToken});
 }
