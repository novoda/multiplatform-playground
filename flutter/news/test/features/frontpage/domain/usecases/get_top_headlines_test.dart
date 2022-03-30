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
  late MockArticlesRepository repository;
  late List<Article> topArticles;

  setUp(() {
    repository = MockArticlesRepository();
    usecase = GetTopHeadlines(repository: repository);
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
    'GIVEN repository sync will succeed WHEN syncing THEN succeeds',
    () async {
      when(repository.sync()).thenAnswer((_) async => Result.completed());

      final result = await usecase.sync();

      expect(result, Result.completed());
    },
  );

  test(
    'GIVEN repository sync will fail WHEN syncing THEN fails',
    () async {
      when(repository.sync()).thenAnswer(
        (_) async => const ServerFailure(message: "Unable to load news")
            .asFailure<void>(),
      );

      final result = await usecase.sync();

      expect(
        result,
        const ServerFailure(message: "Unable to load news").asFailure<void>(),
      );
    },
  );

  test(
    'GIVEN articles will be returned from database WHEN requesting articles THEN returns articles',
    () async {
      when(repository.topHeadlines())
          .thenAnswer((_) => Stream.value(topArticles));

      var result = usecase.topHeadlines();

      expect(result, emits(topArticles));
    },
  );
}
