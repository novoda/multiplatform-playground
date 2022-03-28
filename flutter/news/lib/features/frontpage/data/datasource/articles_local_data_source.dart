import 'dart:async';

import 'package:news/core/error/failures.dart';
import 'package:news/core/news_database_client.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

// TODO to include a real persistence layer, something like a database using something like https://drift.simonbinder.eu
class ArticlesLocalDataSource {
  StreamController<List<Article>>? _controller;
  final DB _db;

  ArticlesLocalDataSource(this._db);

  Stream<List<Article>> topHeadLines() {
    _controller ??= StreamController(
      onListen: () => _db.read().then((articles) => _controller!.add(articles)),
    );
    return _controller!.stream;
  }

  Future<Result<void>> save(List<Article> topHeadlines) => _db
      .save(topHeadlines)
      .then((value) => _controller?.add(topHeadlines))
      .then((result) => Result<void>.completed())
      .catchError(
        (error) => const Result<void>.failure(
          failure: CacheFailure(message: "Unable to save news on database"),
        ),
      );
}
