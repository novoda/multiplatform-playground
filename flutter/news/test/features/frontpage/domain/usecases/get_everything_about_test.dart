import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';
import 'package:news/features/frontpage/domain/usecases/get_everything_about.dart';

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
      const Article(
        source: Source(id: "id", name: "name"),
        author: "author",
        title: "title",
        description: "description",
        url: "url",
        urlToImage: "urlToImage",
        publishedAt: "publishedAt",
        content: "content",
      )
    ];
    query = "peace";
  });

  test(
    'GIVEN getting everything about will succeed WHEN calling use case THEN returns matching articles ',
    () async {
      when(articlesRepository.everythingAbout(query))
          .thenAnswer((_) async => matchingArticles.asSuccess());

      final result = await usecase.everythingAbout(query);

      expect(result, matchingArticles.asSuccess());
    },
  );

  test(
    'GIVEN getting everything about will fail WHEN calling use case THEN returns failure ',
    () async {
      when(articlesRepository.everythingAbout(query)).thenAnswer(
        (_) async => const ServerFailure(message: "Error on server")
            .asFailure<List<Article>>(),
      );

      final result = await usecase.everythingAbout(query);

      expect(
        result,
        const ServerFailure(message: "Error on server")
            .asFailure<List<Article>>(),
      );
    },
  );
}
