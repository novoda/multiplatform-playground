import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/source_model.dart';

import '../repositories/articles_repository_test.mocks.dart';

@GenerateMocks([ArticlesLocalDataSource])
void main() {
  late ArticlesLocalDataSource localDataSource;
  late MockArticlesLocalDataSource mockLocalDataSource;

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

  setUp(() {
    localDataSource = ArticlesLocalDataSource();
    mockLocalDataSource = MockArticlesLocalDataSource();
  });

  test(
    'GIVEN articles list successfully saved WHEN getting articles THEN returns correct list of articles ',
    () async {
      localDataSource.save(topHeadlines: articles);

      var result = await localDataSource.topHeadLines();

      expect(result.data, articles);
    },
  );

  test(
    'GIVEN nothing is saved in cache WHEN getting articles THEN returns CacheFailure ',
    () async {
      var result = await localDataSource.topHeadLines();

      expect(result.failure, CacheFailure("No headlines saved"));
    },
  );

  test(
    'GIVEN articles list successfully saved WHEN getting articles fails decoding THEN returns { ',
    () async {
      when(mockLocalDataSource.topHeadLines()).thenAnswer(
          (realInvocation) async =>
              Result.failure(CacheFailure("Failure reading from server")));

      mockLocalDataSource.save(topHeadlines: articles);
      var result = await mockLocalDataSource.topHeadLines();

      expect(result.failure, CacheFailure("No headlines saved"));
    },
  );
}
