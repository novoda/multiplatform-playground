import 'package:news/core/error/failures.dart';
import 'package:news/core/news_api_client.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class ArticlesRemoteDataSource {
  final NewsApiClient client;
  ArticlesRemoteDataSource({required this.client});

  Future<Result<List<Article>>> topHeadLines({country = "us"}) => client
      .topHeadLines(country)
      .then((value) => Result<List<Article>>.success(data: value.articles))
      .catchError(
        (error) => Result<List<Article>>.failure(
          failure: ServerFailure(
            message: error?.toString() ?? "Unable to read from News API",
          ),
        ),
      );

  Future<Result<List<Article>>> getEverythingAbout(String query) {
    throw UnimplementedError();
  }
}
