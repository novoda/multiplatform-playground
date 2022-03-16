import 'dart:convert';

import 'package:news/core/result.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result.dart';
import '../../domain/entities/article.dart';

// TODO to include a real persistence layer, something like a database using something like https://drift.simonbinder.eu
class ArticlesLocalDataSource {
  String _topHeadlinesJson = "";
  final JsonCodec _codec;

  ArticlesLocalDataSource(this._codec);

  Future<Result<List<Article>>> topHeadLines() {
    try {
      var jsonMap = _codec.decode(_topHeadlinesJson);

      List<Article> articles =
          List<Article>.from(jsonMap.map((model) => Article.fromJson(model)));

      if (articles.isNotEmpty) {
        return Future.value(Result.success(articles));
      } else {
        return Future.value(Result.failure(CacheFailure("No headlines saved")));
      }
    } catch (e) {
      return Future.value(
          Result.failure(CacheFailure("Error decoding stored headlines")));
    }
  }

  Future<void> save({required List<Article> topHeadlines}) async {
    if (topHeadlines.isNotEmpty) {
      _topHeadlinesJson = _codec.encode(topHeadlines);
    }
  }
}
