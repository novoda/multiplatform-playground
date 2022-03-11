import 'package:news/core/result.dart';

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

  Future<Result<List<Article>>> getEverythingAbout(String query) {
    // TODO: implement getEverythingAbout
    throw UnimplementedError();
  }

  Future<Result<List<Article>>> topHeadlines() async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getTopHeadlines();
      if (result.isSuccess) {
        localDataSource.cacheTopHeadlines(result.data);
      }
      return result;
    } else {
      return localDataSource.getLastTopHeadlines();
    }
  }
}
