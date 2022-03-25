import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';

import 'articles_repository_test.mocks.dart';

@GenerateMocks([ArticlesLocalDataSource])
@GenerateMocks(
  [ArticlesRemoteDataSource],
  customMocks: [
    MockSpec<ArticlesRemoteDataSource>(
      as: #MockArticlesRemoteDataSourceForTest,
      returnNullOnMissingStub: true,
    ),
  ],
)
void main() {
  late ArticlesRepository repository;
  late MockArticlesRemoteDataSource remoteDataSource;
  late MockArticlesLocalDataSource localDataSource;
  const remoteArticles = [
    Article(
      source: Source(id: "id", name: "remote"),
      author: "author",
      title: "title",
      description: "description",
      url: "url",
      urlToImage: "urlToImage",
      publishedAt: "publishedAt",
      content: "content",
    )
  ];
  const localArticles = [
    Article(
      source: Source(id: "id", name: "local"),
      author: "author",
      title: "title",
      description: "description",
      url: "url",
      urlToImage: "urlToImage",
      publishedAt: "publishedAt",
      content: "content",
    )
  ];
  setUp(() {
    remoteDataSource = MockArticlesRemoteDataSource();
    localDataSource = MockArticlesLocalDataSource();
    repository = ArticlesRepository(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  });

  test(
    'GIVEN remote fetch will succeed WHEN getting top articles THEN saves articles on local AND returns local articles',
    () async {
      when(remoteDataSource.topHeadLines())
          .thenAnswer((realInvocation) async => remoteArticles.asSuccess());
      when(localDataSource.topHeadLines())
          .thenAnswer((realInvocation) async => localArticles.asSuccess());

      var result = await repository.topHeadlines();

      verify(localDataSource.save(topHeadlines: remoteArticles));
      expect(result, localArticles.asSuccess());
    },
  );

  test(
    'GIVEN remote fetch will fail WHEN getting top articles THEN does not saves articles on local AND returns local articles',
    () async {
      when(remoteDataSource.topHeadLines()).thenAnswer(
        (realInvocation) async =>
            const ServerFailure(message: "Failure reading from server")
                .asFailure<List<Article>>(),
      );
      when(localDataSource.topHeadLines())
          .thenAnswer((realInvocation) async => localArticles.asSuccess());

      var result = await repository.topHeadlines();

      verifyNever(localDataSource.save(topHeadlines: remoteArticles));
      expect(result, localArticles.asSuccess());
    },
  );

  test(
    'GIVEN local fetch will fail WHEN getting top articles THEN returns failure',
    () async {
      when(remoteDataSource.topHeadLines())
          .thenAnswer((realInvocation) async => remoteArticles.asSuccess());
      when(localDataSource.topHeadLines()).thenAnswer(
        (realInvocation) async =>
            const CacheFailure(message: "Error reading from cache")
                .asFailure<List<Article>>(),
      );

      var result = await repository.topHeadlines();

      expect(
        result,
        const CacheFailure(message: 'Error reading from cache')
            .asFailure<List<Article>>(),
      );
    },
  );
}
