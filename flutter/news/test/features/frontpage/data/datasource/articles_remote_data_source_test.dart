import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/news_api_client.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/base_news_response.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import 'articles_remote_data_source_test.mocks.dart';

@GenerateMocks([NewsApiClient])
void main() {
  late ArticlesRemoteDataSource remoteDataSource;
  late MockNewsApiClient apiClient;

  setUp(() {
    apiClient = MockNewsApiClient();
    remoteDataSource = ArticlesRemoteDataSource(client: apiClient);
  });

  test(
    'GIVEN topHeadlines request is done WHEN request is successful 200 THEN response should be List<ArticleModel>',
    () async {
      var response =
          BaseNewsResponse.fromJson(json.decode(fixture("articles.json")));
      when(apiClient.topHeadLines("us")).thenAnswer((_) async => response);

      final result = await remoteDataSource.topHeadLines();

      expect(result, response.articles.asSuccess());
    },
  );

  test(
    'GIVEN topHeadlines request is done WHEN request fails THEN response should be ServerFailure',
    () async {
      when(apiClient.topHeadLines("us"))
          .thenAnswer((_) async => throw Exception());

      final result = await remoteDataSource.topHeadLines();

      expect(
        result,
        ServerFailure(message: "Unable to read news from API")
            .asFailure<List<Article>>(),
      );
    },
  );
}
