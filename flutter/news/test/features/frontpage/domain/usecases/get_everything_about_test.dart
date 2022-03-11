import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';
import 'package:news/features/frontpage/domain/usecases/get_everything_about.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';

import 'get_top_headlines_test.mocks.dart';

@GenerateMocks([ArticlesRepository])
void main() {
  late GetEverythingAbout usecase;
  late MockArticlesRepository articlesRepository;
  late List<Article> matchingArticles;
  late String query;

  setUp(() {
    articlesRepository = MockArticlesRepository();
    usecase = GetEverythingAbout(articlesRepository);
    matchingArticles = [
      Article(
          source: Source(id: "id", name: "name"),
          author: "author",
          title: "title",
          description: "description",
          url: "url",
          urlToImage: "urlToImage",
          publishedAt: "publishedAt",
          content: "content")
    ];
    query = "peace";
  });

  test(
    'GIVEN getting everything about will succeed WHEN calling use case THEN returns matching articles ',
    () async {
      when(articlesRepository.getEverythingAbout(query))
          .thenAnswer((_) async => Result.success(matchingArticles));

      final result = await usecase(Params(query: query));

      expect(result.data, matchingArticles);
    },
  );

  test(
    'GIVEN getting everything about will fail WHEN calling use case THEN returns failure ',
    () async {
      when(articlesRepository.getEverythingAbout(query)).thenAnswer(
          (_) async => Result.failure(ServerFailure("Error on server")));

      final result = await usecase(Params(query: query));

      expect(result.failure, isInstanceOf<ServerFailure>());
    },
  );
}
