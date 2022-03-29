import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news/features/frontpage/domain/entities/base_news_response.dart';
import 'package:retrofit/retrofit.dart';

part 'news_api_client.g.dart';

@RestApi(baseUrl: "https://newsapi.org")
abstract class NewsApiClient {
  factory NewsApiClient(Dio dio, {String baseUrl}) = _NewsApiClient;

  factory NewsApiClient.create() => NewsApiClient(_createDio());

  @GET("/v2/top-headlines")
  Future<BaseNewsResponse> topHeadLines(
    @Query("country") String country,
  );
}

Dio _createDio() {
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
