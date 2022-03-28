import 'package:news/core/error/failures.dart';
import 'package:news/core/news_api_client.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class ArticlesRemoteDataSource {
  final NewsApiClient _client;
  ArticlesRemoteDataSource(this._client);

  Future<Result<List<Article>>> topHeadLines() => _client
      .topHeadLines()
      .then((value) => Result<List<Article>>.success(data: value.articles))
      .catchError(
        (error) => const Result<List<Article>>.failure(
          failure: ServerFailure(message: "Unable to read news from API"),
        ),
      );

  Future<Result<List<Article>>> getEverythingAbout(String query) {
    throw UnimplementedError();
  }
}
