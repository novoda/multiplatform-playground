import 'dart:convert';

import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/result.dart';

class ArticlesLocalDataSource {
  String _topHeadlinesJson = "";
  final JsonCodec _codec;

  ArticlesLocalDataSource(this._codec);

  Future<Result<List<ArticleModel>>> topHeadLines() {
    try {
      var jsonMap = _codec.decode(_topHeadlinesJson);

      List<ArticleModel> articles = List<ArticleModel>.from(
          jsonMap.map((model) => ArticleModel.fromJson(model)));

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

  Future<void> save({required List<ArticleModel> topHeadlines}) async {
    if (topHeadlines.isNotEmpty) {
      _topHeadlinesJson = _codec.encode(topHeadlines);
    }
  }
}
