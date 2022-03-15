import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/source_model.dart';

import 'articles_local_data_source_test.mocks.dart';

@GenerateMocks([ArticlesLocalDataSource, JsonCodec])
void main() {
  late ArticlesLocalDataSource localDataSource;

  final articles = [
    ArticleModel(
        source: SourceModel(id: "id", name: "local"),
        author: "author",
        title: "title",
        description: "description",
        url: "url",
        urlToImage: "urlToImage",
        publishedAt: "publishedAt",
        content: "content")
  ];

  test(
    'GIVEN articles list successfully saved WHEN getting articles THEN returns correct list of articles ',
    () async {
      localDataSource = ArticlesLocalDataSource(const JsonCodec());
      localDataSource.save(topHeadlines: articles);

      var result = await localDataSource.topHeadLines();

      expect(result.data, articles);
    },
  );

  test(
    'GIVEN nothing is saved in cache WHEN getting articles THEN returns CacheFailure ',
    () async {
      localDataSource = ArticlesLocalDataSource(const JsonCodec());

      var result = await localDataSource.topHeadLines();

      expect(result.failure, CacheFailure("No headlines saved"));
    },
  );

  test(
    'GIVEN will fail to decode list from json WHEN getting articles THEN returns CacheFailure { ',
    () async {
      var jsonCodec = MockJsonCodec();
      localDataSource = ArticlesLocalDataSource(jsonCodec);
      when(jsonCodec.decode(any))
          .thenThrow(JsonUnsupportedObjectError("Error"));

      var result = await localDataSource.topHeadLines();

      expect(result.failure, CacheFailure("No headlines saved"));
    },
  );
}
