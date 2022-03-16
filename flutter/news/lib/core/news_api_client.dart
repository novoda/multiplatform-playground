import 'package:dio/dio.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/base_news_response.dart';
import 'package:retrofit/retrofit.dart';
part 'news_api_client.g.dart';

@RestApi(baseUrl: "https://newsapi.org")
abstract class NewsApiClient {
  factory NewsApiClient(Dio dio, {String baseUrl}) = _NewsApiClient;

  @GET("/v2/top-headlines")
  Future<BaseNewsResponse> topHeadLines();
}
