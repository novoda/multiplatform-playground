import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';

import 'get_top_headlines_test.mocks.dart';

@GenerateMocks([ArticlesRepository])
void main() {
  late GetTopHeadlines usecase;
  late MockArticlesRepository articlesRepository;
  late List<Article> topArticles;

  setUp(() {
    articlesRepository = MockArticlesRepository();
    usecase = GetTopHeadlines(articlesRepository);
    topArticles = [
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
  });

  test(
    'GIVEN reading top headlines will succeed WHEN reading top articles THEN returns top articles',
    () async {
      when(articlesRepository.topHeadlines())
          .thenAnswer((_) async => topArticles.asSuccess());

      final result = await usecase.topHeadlines();

      expect(result, topArticles.asSuccess());
    },
  );

  test(
    'GIVEN reading top headlines will faill WHEN reading top articles THEN returns failure',
    () async {
      when(articlesRepository.topHeadlines()).thenAnswer(
        (_) async => const ServerFailure(message: "Error reading from server")
            .asFailure<List<Article>>(),
      );

      final result = await usecase.topHeadlines();

      expect(
        result,
        const ServerFailure(message: "Error reading from server")
            .asFailure<List<Article>>(),
      );
    },
  );
}
