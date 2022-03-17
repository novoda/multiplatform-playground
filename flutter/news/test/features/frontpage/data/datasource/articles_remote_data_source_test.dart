import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/data/datasource/key_provider.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/base_news_response_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import 'articles_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client, KeyProvider])
void main() {
  late ArticlesRemoteDataSource remoteDataSource;
  late MockClient httpClient;
  late MockKeyProvider keyProvider;

  final testResult = Result.success(
      BaseNewsResponseModel.fromJson(json.decode(fixture("articles.json")))
          .articles as List<ArticleModel>);

  setUp(() {
    httpClient = MockClient();
    keyProvider = MockKeyProvider();
    when(keyProvider.newsApiKey()).thenReturn("1250012360");
    remoteDataSource =
        ArticlesRemoteDataSource(client: httpClient, keyProvider: keyProvider);
  });

  test(
    'GIVEN Get request is done WHEN doing the request THEN the endpoint '
    'being used should be /v2/top-headlines',
    () async {
      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
          (_) async => http.Response(fixture("articles.json"), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      remoteDataSource.topHeadLines();
      verify(httpClient.get(
          Uri.parse("https://newsapi.org/v2/top-headlines?country=us"),
          headers: anyNamed("headers")));
    },
  );

  test(
    'GIVEN topHeadlines request is done WHEN request is successful and '
    'returns 200 THEN response should be List<ArticleModel>',
    () async {
      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
          (_) async => http.Response(fixture("articles.json"), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      final result = await remoteDataSource.topHeadLines();

      expect(result, testResult);
    },
  );

  test(
    'GIVEN topHeadlines request is done WHEN request fails and '
    'returns 404 THEN response should be ServerFailure',
    () async {
      when(httpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
          (_) async => http.Response("Error", 404, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      final result = await remoteDataSource.topHeadLines();

      expect(result.failure, isA<ServerFailure>());
    },
  );
}
