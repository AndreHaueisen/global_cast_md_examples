import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class ApiDio {
  static const _baseUrl = 'https://staycurrent.globalcastmd.com/api/v2/';
  final Dio dio;

  ApiDio()
      : dio = Dio(BaseOptions(
          baseUrl: _baseUrl,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
        )) {
    dio.interceptors.add(DioCacheInterceptor(
      options: CacheOptions(
        store: MemCacheStore(),
        policy: CachePolicy.forceCache,
        maxStale: const Duration(minutes: 15),
      ),
    ));
  }
}
