import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/base_news_response_model.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import 'articles_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late ArticlesRemoteDataSource remoteDataSource;
  late MockClient mockHttpClient;

  final testResult = Result.success(
      BaseNewsResponseModel.fromJson(json.decode(fixture("articles.json")))
          .articles as List<ArticleModel>);

  setUp(() {
    mockHttpClient = MockClient();
    remoteDataSource = ArticlesRemoteDataSource(client: mockHttpClient);
  });

  test(
    'Given Get request is done When doing the request Then the endpoint '
    'being used should be /v2/top-headlines',
    () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
          (_) async => http.Response(fixture("articles.json"), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      remoteDataSource.topHeadLines();
      //assert
      verify(mockHttpClient.get(
          Uri.parse("https://newsapi.org/v2/top-headlines?country=us"),
          headers: anyNamed("headers")));
    },
  );

  test(
    'Given topHeadlines request is done When request is successful and '
    'returns 200 Then response should be List<ArticleModel>',
    () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed("headers"))).thenAnswer(
          (_) async => http.Response(fixture("articles.json"), 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));
      // act
      final result = await remoteDataSource.topHeadLines();
      //assert
      expect(result, testResult);
    },
  );

  test(
    'Given topHeadlines request is done When request fails and '
    'returns 404 Then response should be ServerFailure',
    () async {
      // arrange
      when(mockHttpClient.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response("Error", 404));
      // act
      final call = remoteDataSource.topHeadLines;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerFailure>()));
    },
  );
}