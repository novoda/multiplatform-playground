import 'package:dartz/dartz.dart';
import 'package:news/core/error/exceptions.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/article.dart';
import '../datasource/articles_data_source.dart';
import '../datasource/articles_local_data_source.dart';

class ArticlesRepository {
  final ArticlesLocalDataSource localDataSource;
  final ArticlesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ArticlesRepository(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  Future<Either<Failure, List<Article>>> getEverythingAbout(String query) {
    // TODO: implement getEverythingAbout
    throw UnimplementedError();
  }

  Future<Either<Failure, List<Article>>> getTopHeadlines() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticles = await remoteDataSource.getTopHeadlines();
        localDataSource.cacheTopHeadlines(remoteArticles);
        return Right(remoteArticles);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localArticles = await localDataSource.getLastTopHeadlines();
        return Right(localArticles);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }
}
