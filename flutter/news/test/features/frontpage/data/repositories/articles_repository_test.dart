import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/network/network_info.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/source_model.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';

import 'articles_repository_test.mocks.dart';

@GenerateMocks([NetworkInfo, ArticlesLocalDataSource])
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
  late MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockArticlesRemoteDataSource();
    localDataSource = MockArticlesLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = ArticlesRepository(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource,
        networkInfo: networkInfo);
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(networkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(networkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      body();
    });
  }

  group("get top Articles", () {
    final topArticles = [
      ArticleModel(
          source: SourceModel(id: "id", name: "name"),
          author: "author",
          title: "title",
          description: "description",
          url: "url",
          urlToImage: "urlToImage",
          publishedAt: "publishedAt",
          content: "content")
    ];

    runTestsOnline(() {
      test(
        'should return remote data when call to remote data is success',
        () async {
          when(remoteDataSource.getTopHeadlines()).thenAnswer(
              (realInvocation) async => Result.success(topArticles));

          final result = await repository.topHeadlines();

          verify(remoteDataSource.getTopHeadlines());
          expect(result.data, topArticles);
        },
      );

      test(
        'should return server failure when call to remote data fails',
        () async {
          when(remoteDataSource.getTopHeadlines()).thenAnswer(
              (realInvocation) async =>
                  Result.failure(ServerFailure("exception")));

          final result = await repository.topHeadlines();

          verify(remoteDataSource.getTopHeadlines());
          verifyZeroInteractions(localDataSource);
          expect(result.failure, isInstanceOf<ServerFailure>());
        },
      );

      test(
        'should cache data locally when call to remote data is success',
        () async {
          when(remoteDataSource.getTopHeadlines()).thenAnswer(
              (realInvocation) async => Result.success(topArticles));

          await repository.topHeadlines();

          verify(remoteDataSource.getTopHeadlines());
          verify(localDataSource.cacheTopHeadlines(topArticles));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return cached data when device is offline && has cache data',
        () async {
          when(localDataSource.getLastTopHeadlines()).thenAnswer(
              (realInvocation) async => Result.success(topArticles));

          final result = await repository.topHeadlines();

          verifyNoMoreInteractions(remoteDataSource);
          verify(localDataSource.getLastTopHeadlines());
          expect(result.data, topArticles);
        },
      );

      test(
        'should return cached failure when there is no cached values',
        () async {
          when(localDataSource.getLastTopHeadlines()).thenAnswer(
              (realInvocation) async =>
                  Result.failure(CacheFailure("problem reading from cache")));
          final result = await repository.topHeadlines();

          verifyNoMoreInteractions(remoteDataSource);
          verify(localDataSource.getLastTopHeadlines());
          expect(result.failure, isInstanceOf<CacheFailure>());
        },
      );
    });
  });
}
