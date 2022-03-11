import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/source_model.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';

import 'articles_repository_test.mocks.dart';

@GenerateMocks([ArticlesLocalDataSource])
@GenerateMocks([
  ArticlesRemoteDataSource
], customMocks: [
  MockSpec<ArticlesRemoteDataSource>(
      as: #MockArticlesRemoteDataSourceForTest, returnNullOnMissingStub: true),
])
void main() {
  late ArticlesRepository repository;
  late MockArticlesRemoteDataSource remoteDataSource;
  late MockArticlesLocalDataSource localDataSource;
  final remoteArticles = [
    ArticleModel(
        source: SourceModel(id: "id", name: "remote"),
        author: "author",
        title: "title",
        description: "description",
        url: "url",
        urlToImage: "urlToImage",
        publishedAt: "publishedAt",
        content: "content")
  ];
  final localArticles = [
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
    remoteDataSource = MockArticlesRemoteDataSource();
    localDataSource = MockArticlesLocalDataSource();
    repository = ArticlesRepository(
        remoteDataSource: remoteDataSource, localDataSource: localDataSource);
  });

  test(
    'GIVEN remote fetch will succeed WHEN getting top articles THEN saves articles on local AND returns local articles',
    () async {
      when(remoteDataSource.getTopHeadlines())
          .thenAnswer((realInvocation) async => Result.success(remoteArticles));
      when(localDataSource.getLastTopHeadlines())
          .thenAnswer((realInvocation) async => Result.success(localArticles));

      var result = await repository.topHeadlines();

      verify(localDataSource.cacheTopHeadlines(remoteArticles));
      expect(result.data, localArticles);
    },
  );

  test(
    'GIVEN remote fetch will fail WHEN getting top articles THEN does not saves articles on local AND returns local articles',
    () async {
      when(remoteDataSource.getTopHeadlines()).thenAnswer(
          (realInvocation) async =>
              Result.failure(ServerFailure("Failure reading from server")));
      when(localDataSource.getLastTopHeadlines())
          .thenAnswer((realInvocation) async => Result.success(localArticles));

      var result = await repository.topHeadlines();

      verifyNever(localDataSource.cacheTopHeadlines(remoteArticles));
      expect(result.data, localArticles);
    },
  );

  test(
    'GIVEN local fetch will fail WHEN getting top articles THEN returns failure',
    () async {
      when(remoteDataSource.getTopHeadlines())
          .thenAnswer((realInvocation) async => Result.success(remoteArticles));
      when(localDataSource.getLastTopHeadlines()).thenAnswer(
          (realInvocation) async =>
              Result.failure(CacheFailure('Error reading from cache')));

      var result = await repository.topHeadlines();

      expect(result.failure, isInstanceOf<CacheFailure>());
    },
  );
}
