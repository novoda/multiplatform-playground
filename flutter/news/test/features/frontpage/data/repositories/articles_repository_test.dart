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
      localDataSource: localDataSource,
      remoteDataSource: remoteDataSource,
    );
  });

  test(
    'GIVEN remote fetch will succeed WHEN syncing THEN saves articles on local AND returns success',
    () async {
      when(remoteDataSource.topHeadLines())
          .thenAnswer((realInvocation) async => remoteArticles.asSuccess());
      when(localDataSource.save(any))
          .thenAnswer((realInvocation) async => Result.completed());

      var result = await repository.sync();

      verify(localDataSource.save(remoteArticles));
      expect(result, Result.completed());
    },
  );

  test(
    'GIVEN remote fetch will succeed AND saving into local store will fail WHEN syncing THEN returns failure',
    () async {
      when(remoteDataSource.topHeadLines())
          .thenAnswer((realInvocation) async => remoteArticles.asSuccess());
      when(localDataSource.save(any)).thenAnswer(
        (realInvocation) async =>
            const CacheFailure(message: "Unable to save in repository")
                .asFailure<void>(),
      );

      var result = await repository.sync();

      expect(
        result,
        const CacheFailure(message: "Unable to save in repository")
            .asFailure<void>(),
      );
    },
  );

  test(
    'GIVEN remote fetch will fail WHEN syncing THEN does not saves articles on local AND returns a failure',
    () async {
      when(remoteDataSource.topHeadLines()).thenAnswer(
        (realInvocation) async =>
            const ServerFailure(message: "Failure reading from server")
                .asFailure<List<Article>>(),
      );

      var result = await repository.sync();

      verifyNever(localDataSource.save(any));
      expect(
        result,
        const ServerFailure(message: "Failure reading from server")
            .asFailure<void>(),
      );
    },
  );

  test(
    'GIVEN articles will be returned from database WHEN requesting articles from repository THEN returns articles',
    () async {
      when(localDataSource.topHeadLines())
          .thenAnswer((_) => Stream.value(localArticles));

      var result = repository.topHeadlines();

      expect(result, emits(localArticles));
    },
  );
}
