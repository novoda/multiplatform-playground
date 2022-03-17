import 'package:news/core/error/failures.dart';
import 'package:news/core/news_api_client.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

class ArticlesRemoteDataSource {
  final NewsApiClient client;
  ArticlesRemoteDataSource({required this.client});

  Future<Result<List<Article>>> topHeadLines() async {
    var result = await client
        .topHeadLines()
        .then((value) => Result<List<Article>>.success(value.articles))
        .catchError((error) => Result<List<Article>>.failure(
            ServerFailure("Unable to read news from API")));

    return result;
  }

  Future<Result<List<Article>>> getEverythingAbout(String query) {
    throw UnimplementedError();
  }
}
