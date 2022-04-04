import 'dart:async';

import 'package:news/core/error/failures.dart';
import 'package:news/core/news_database_client.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:rxdart/rxdart.dart';

// TODO to include a real persistence layer, something like a database using something like https://drift.simonbinder.eu
class ArticlesLocalDataSource {
  BehaviorSubject<List<Article>>? _subject;
  final DB<List<Article>> db;

  ArticlesLocalDataSource({required this.db});

  Stream<List<Article>> topHeadLines() {
    _subject ??= BehaviorSubject(
      onListen: () => db.read().then((articles) => _subject!.add(articles)),
    );
    return _subject!.stream;
  }

  Future<Result<void>> save(List<Article> topHeadlines) => db
      .save(topHeadlines)
      .then((value) => _subject?.add(topHeadlines))
      .then((result) => Result<void>.completed())
      .catchError(
        (error) => CacheFailure(
          message: error?.toString() ?? "Unable to save news on database",
        ).asFailure<void>(),
      );
}
