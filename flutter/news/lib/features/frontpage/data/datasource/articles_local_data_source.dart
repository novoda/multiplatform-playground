import 'dart:convert';

import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

// TODO to include a real persistence layer, something like a database using something like https://drift.simonbinder.eu
class ArticlesLocalDataSource {
  String _topHeadlinesJson = "[]";
  final JsonCodec jsonCodec;

  ArticlesLocalDataSource({required this.jsonCodec});

  Future<Result<List<Article>>> topHeadLines() {
    try {
      var jsonMap = jsonCodec.decode(_topHeadlinesJson);

      List<Article> articles =
          List<Article>.from(jsonMap.map((model) => Article.fromJson(model)));

      if (articles.isNotEmpty) {
        return Future.value(Result<List<Article>>.success(data: articles));
      } else {
        return Future.value(
          const Result<List<Article>>.failure(
            failure: CacheFailure(message: "No headlines saved"),
          ),
        );
      }
    } catch (e) {
      return Future.value(
        const Result<List<Article>>.failure(
          failure: CacheFailure(message: "Error decoding stored headlines"),
        ),
      );
    }
  }

  Future<void> save({required List<Article> topHeadlines}) async {
    if (topHeadlines.isNotEmpty) {
      _topHeadlinesJson = jsonCodec.encode(topHeadlines);
    }
  }
}
