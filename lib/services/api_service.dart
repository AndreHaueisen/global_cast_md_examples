import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'api_dio.dart';

class ApiService {
  @protected
  final ApiDio dio;

  const ApiService(this.dio);

  Future<ResponseResult<T>> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final result = await dio.dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return ResponseResult.success(result.data);
    } on DioError catch (e) {
      return ResponseResult.error(
          DioErrorHandler.dioErrorToString(dioError: e));
    }
  }

  Future<ResponseResult<T>> post<T>({
    required String path,
    dynamic data,
    Map<String, String>? headers,
  }) async {
    try {
      final result = await dio.dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );

      return ResponseResult.success(result.data);
    } on DioError catch (e) {
      return ResponseResult.error(
          DioErrorHandler.dioErrorToString(dioError: e));
    }
  }

  Future<ResponseResult<T>> put<T>({
    required String path,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final result = await dio.dio.put(
        path,
        data: data,
        options: Options(headers: headers),
      );

      return ResponseResult.success(result.data);
    } on DioError catch (e) {
      return ResponseResult.error(
          DioErrorHandler.dioErrorToString(dioError: e));
    }
  }

  Future<ResponseResult<T>> patch<T>({
    required String path,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      final result = await dio.dio.patch(
        path,
        data: data,
        options: Options(headers: headers),
      );

      return ResponseResult.success(result.data);
    } on DioError catch (e) {
      return ResponseResult.error(
          DioErrorHandler.dioErrorToString(dioError: e));
    }
  }

  Future<ResponseResult<T>> delete<T>({
    required String path,
    Map<String, String>? headers,
  }) async {
    try {
      final result = await dio.dio.delete(
        path,
        options: Options(headers: headers),
      );

      return ResponseResult.success(result.data);
    } on DioError catch (e) {
      return ResponseResult.error(
          DioErrorHandler.dioErrorToString(dioError: e));
    }}
}

class ResponseResult<T> extends Equatable {
  final T? data;
  final String? errorMessage;

  const ResponseResult.success(this.data) : errorMessage = null;

  const ResponseResult.error(this.errorMessage) : data = null;

  bool get isSuccess => errorMessage == null;

  @override
  List<Object?> get props => [data, errorMessage];
}

class DioErrorHandler {
  const DioErrorHandler._();

  static String dioErrorToString({required DioError dioError}) {
    late final String errorText;
    switch (dioError.type) {
      case DioErrorType.connectTimeout:
        errorText =
            'Connection Timeout. Check your Internet connection or contact '
            'Server administrator';
        break;
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        errorText =
            'Connection lost, please check your internet connection and '
            'try again.';
        break;
      case DioErrorType.response:
        errorText = _errorBaseOnHttpStatusCode(dioError: dioError);
        break;
      case DioErrorType.other:
        errorText =
            'Connection lost, please check your internet connection and '
            'try again.';
        break;
      case DioErrorType.cancel:
        errorText =
            'Connection lost, please check your internet connection and '
            'try again.';
        break;
    }
    return errorText;
  }

  static String _errorBaseOnHttpStatusCode({required DioError dioError}) {
    String errorText;
    if (dioError.response != null) {
      if (dioError.response?.statusCode == 401) {
        errorText =
            'Something went wrong, please close the app and login again.';
      } else if (dioError.response?.statusCode == 404) {
        errorText = 'Connection lost, please check your internet '
            'connection and try again.';
      } else if (dioError.response?.statusCode == 500) {
        errorText = 'We could not connect to the product server. '
            'Please contact Server administrator';
      } else {
        errorText =
            'Something went wrong, please close the app and login again. '
            'If the issue persists contact server administrator';
      }
    } else {
      errorText = 'Something went wrong, please close the app and login again. '
          'If the issue persists contact server administrator';
    }

    return errorText;
  }
}
