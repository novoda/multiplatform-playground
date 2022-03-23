import 'package:news/core/language_extensions.dart';
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
    result.fold(
        ifSuccess: (data) => localDataSource.save(topHeadlines: data),
        ifFailure: (failure) => doNothing(because: "There is nothing to save"));

    return localDataSource.topHeadLines();
  }
}
