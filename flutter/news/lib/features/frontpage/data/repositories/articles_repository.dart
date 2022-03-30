import 'package:news/core/language_extensions.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/datasource/articles_remote_data_source.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class ArticlesRepository {
  final ArticlesLocalDataSource localDataSource;
  final ArticlesRemoteDataSource remoteDataSource;

  ArticlesRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<Result<List<Article>>> everythingAbout(String query) {
    // TODO: implement getEverythingAbout
    throw UnimplementedError();
  }

  Stream<List<Article>> topHeadlines() => localDataSource.topHeadLines();

  Future<Result<void>> sync() => remoteDataSource.topHeadLines().when(
        success: (data) => localDataSource.save(data),
        failure: (failure) => failure.asFailure<void>(),
      );
}
