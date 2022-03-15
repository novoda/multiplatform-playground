import 'package:news/core/result.dart';

import '../../domain/entities/article.dart';
import '../datasource/articles_local_data_source.dart';
import '../datasource/articles_remote_data_source.dart';

class ArticlesRepository {
  final ArticlesLocalDataSource localDataSource;
  final ArticlesRemoteDataSource remoteDataSource;

  ArticlesRepository(
      {required this.localDataSource, required this.remoteDataSource});

  Future<Result<List<Article>>> everythingAbout(String query) {
    // TODO: implement getEverythingAbout
    throw UnimplementedError();
  }

  Future<Result<List<Article>>> topHeadlines() async {
    final result = await remoteDataSource.topHeadLines();
    if (result.isSuccess) {
      localDataSource.save(topHeadlines: result.data);
    }
    return localDataSource.topHeadLines();
  }
}
