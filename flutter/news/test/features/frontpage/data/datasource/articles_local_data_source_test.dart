import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/news_database_client.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';

import 'articles_local_data_source_test.mocks.dart';

@GenerateMocks([DB])
void main() {
  late ArticlesLocalDataSource localDataSource;

  final articles = [
    const Article(
      source: Source(id: "id", name: "local"),
      author: "author",
      title: "title",
      description: "description",
      url: "url",
      urlToImage: "urlToImage",
      publishedAt: "publishedAt",
      content: "content",
    )
  ];

  test(
    'GIVEN articles list successfully saved WHEN getting articles THEN returns correct list of articles ',
    () async {
      localDataSource = ArticlesLocalDataSource(db: ArticlesDummyDB());
      await localDataSource.save(articles);

      var result = localDataSource.topHeadLines();

      expect(result, emits(articles));
    },
  );

  test(
    'GIVEN nothing is saved in cache WHEN getting articles THEN returns empty list ',
    () async {
      localDataSource = ArticlesLocalDataSource(db: ArticlesDummyDB());

      var result = localDataSource.topHeadLines();

      expect(result, emits([]));
    },
  );

  test(
    'GIVEN will fail to save articles WHEN saving articles THEN returns CacheFailure ',
    () async {
      var db = MockDB<List<Article>>();
      when(db.save(any)).thenAnswer((_) async {
        throw Exception("Unable to save news on database");
      });
      localDataSource = ArticlesLocalDataSource(db: db);

      var result = await localDataSource.save(articles);

      expect(
        result,
        const CacheFailure(
          message: "Exception: Unable to save news on database",
        ).asFailure<void>(),
      );
    },
  );
}
