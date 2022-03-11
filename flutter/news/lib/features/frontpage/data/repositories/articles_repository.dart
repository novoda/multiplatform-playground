import 'package:news/core/result.dart';

import '../../domain/entities/article.dart';
import '../datasource/articles_data_source.dart';
import '../datasource/articles_local_data_source.dart';

class ArticlesRepository {
  final ArticlesLocalDataSource localDataSource;
  final ArticlesRemoteDataSource remoteDataSource;

  ArticlesRepository(
      {required this.localDataSource, required this.remoteDataSource});

  Future<Result<List<Article>>> getEverythingAbout(String query) {
    // TODO: implement getEverythingAbout
    throw UnimplementedError();
  }

  Future<Result<List<Article>>> topHeadlines() async {
    final result = await remoteDataSource.getTopHeadlines();
    if (result.isSuccess) {
      localDataSource.cacheTopHeadlines(result.data);
    }
    return localDataSource.getLastTopHeadlines();
  }
}
