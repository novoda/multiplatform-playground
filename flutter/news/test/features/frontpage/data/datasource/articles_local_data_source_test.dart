import 'package:flutter_test/flutter_test.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/features/frontpage/data/datasource/articles_local_data_source.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/data/models/source_model.dart';

void main() {
  late ArticlesLocalDataSource localDataSource;

  final articles = [
    ArticleModel(
        source: SourceModel(id: "id", name: "local"),
        author: "author",
        title: "title",
        description: "description",
        url: "url",
        urlToImage: "urlToImage",
        publishedAt: "publishedAt",
        content: "content")
  ];

  setUp(() {
    localDataSource = ArticlesLocalDataSource();
  });

   test(
       'GIVEN articles list successfully saved WHEN getting articles THEN returns correct list of articles ',
         () async {
           localDataSource.save(topHeadlines: articles);

           var result = await localDataSource.topHeadLines();

           expect(result.data, articles);
         },
     );

  test(
    'GIVEN nothing is saved in cache WHEN getting articles THEN returns CacheFailure ',
        () async {
      var result = await localDataSource.topHeadLines();

      expect(result.failure, CacheFailure("No headlines saved"));
    },
  );
}
