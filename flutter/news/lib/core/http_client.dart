import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio createDio() {
  final dio = Dio();
  dio.options.headers['X-Api-Key'] = dotenv.env['NEWS_API_KEY'];
  dio.interceptors.add(
    DioLoggingInterceptor(
      level: Level.body,
      compact: false,
    ),
  );
  return dio;
}
