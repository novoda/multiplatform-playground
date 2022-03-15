import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/core/constants.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/key_provider.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/base_news_response_model.dart';

class ArticlesRemoteDataSource {
  final http.Client client;
  final KeyProvider keyProvider;

  ArticlesRemoteDataSource({required this.client, required this.keyProvider});

  Future<Result<List<ArticleModel>>> topHeadLines() async {
    var url = Uri.https(
        Constants.baseUrl, Constants.topHeadlinesEndpoint, {'country': 'us'});
    var response =
        await client.get(url, headers: {'X-Api-Key': keyProvider.newsApiKey()});
    if (response.statusCode == 200) {
      return Result.success(
          BaseNewsResponseModel.fromJson(json.decode(response.body)).articles
              as List<ArticleModel>);
    } else {
      throw ServerFailure("Server failure");
    }
  }

  Future<Result<List<ArticleModel>>> getEverythingAbout(String query) {
    throw UnimplementedError();
  }
}
