import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/exceptions.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/network/network_info.dart';
import 'package:news/features/frontpage/data/datasource/articles_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/source_model.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository_impl.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

import 'articles_repository_impl_test.mocks.dart';


@GenerateMocks([NetworkInfo, ArticlesLocalDataSource])
@GenerateMocks([
  ArticlesRemoteDataSource
], customMocks: [
  MockSpec<ArticlesRemoteDataSource>(
      as: #MockArticlesRemoteDataSourceForTest, returnNullOnMissingStub: true),
])
void main() {
  late ArticlesRepositoryImpl repository;
  late MockArticlesRemoteDataSource mockArticlesRemoteDataSource;
  late MockArticlesLocalDataSource mockArticlesLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockArticlesRemoteDataSource = MockArticlesRemoteDataSource();
    mockArticlesLocalDataSource = MockArticlesLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ArticlesRepositoryImpl(
        remoteDataSource: mockArticlesRemoteDataSource,
        localDataSource: mockArticlesLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });

      body();
    });
  }

  group("get top Articles", () {
    final tArticlesModelList = [
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
    final List<Article> tArticleList = tArticlesModelList;

    runTestsOnline((){

      test(
        'should return remote data when call to remote data is success',
        () async {
          // arrange
          when(mockArticlesRemoteDataSource.getTopHeadlines())
              .thenAnswer((realInvocation) async => tArticlesModelList);
          // act
          final result = await repository.getTopHeadlines();
          //assert
          verify(mockArticlesRemoteDataSource.getTopHeadlines());
          expect(result, Right(tArticleList));
        },
      );

      test(
        'should return server failure when call to remote data fails',
        () async {
          // arrange
          when(mockArticlesRemoteDataSource.getTopHeadlines())
              .thenThrow(ServerException("exception"));
          // act
          final result = await repository.getTopHeadlines();
          //assert
          verify(mockArticlesRemoteDataSource.getTopHeadlines());
          verifyZeroInteractions(mockArticlesLocalDataSource);
          expect(result, const Left(ServerFailure("exception")));
        },
      );

      test(
        'should cache data locally when call to remote data is success',
        () async {
          // arrange
          when(mockArticlesRemoteDataSource.getTopHeadlines())
              .thenAnswer((realInvocation) async => tArticlesModelList);
          // act
          await repository.getTopHeadlines();
          //assert
          verify(mockArticlesRemoteDataSource.getTopHeadlines());
          verify(mockArticlesLocalDataSource
              .cacheTopHeadlines(tArticlesModelList));
        },
      );
    });

    runTestsOffline((){
      test(
        'should return cached data when device is offline && has cache data',
        () async {
          // arrange
          when(mockArticlesLocalDataSource.getLastTopHeadlines())
              .thenAnswer((realInvocation) async => tArticlesModelList);
          // act
          final result = await repository.getTopHeadlines();
          //assert
          verifyNoMoreInteractions(mockArticlesRemoteDataSource);
          verify(mockArticlesLocalDataSource.getLastTopHeadlines());
          expect(result, Right(tArticleList));
        },
      );

      test(
        'should return cached failure when there is no cached values',
        () async {
          // arrange
          when(mockArticlesLocalDataSource.getLastTopHeadlines())
              .thenThrow(CacheException("cacheException"));
          // act
          final result = await repository.getTopHeadlines();
          //assert
          verifyNoMoreInteractions(mockArticlesRemoteDataSource);
          verify(mockArticlesLocalDataSource.getLastTopHeadlines());
          expect(result, const Left(CacheFailure("cacheException")));
        },
      );
    });
  });
}
