import 'package:news/core/language_extensions.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class ArticlesRepository {
  final ArticlesLocalDataSource _localDataSource;
  final ArticlesRemoteDataSource _remoteDataSource;

  ArticlesRepository(this._localDataSource, this._remoteDataSource);

  Future<Result<List<Article>>> everythingAbout(String query) {
    // TODO: implement getEverythingAbout
    throw UnimplementedError();
  }

  Stream<List<Article>> topHeadlines() => _localDataSource.topHeadLines();

  Future<Result<void>> sync() => _remoteDataSource.topHeadLines().when(
        success: (data) => _localDataSource.save(data),
        failure: (failure) => failure.asFailure<void>(),
      );
}
