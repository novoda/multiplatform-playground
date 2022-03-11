import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/result.dart';
import 'package:news/core/usecases/usecase.dart';
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
  });

  test(
    'should get list of top headlines from repository ',
    () async {
      when(articlesRepository.topHeadlines())
          .thenAnswer((_) async => Result.success(topArticles));

      final result = await usecase(NoParams());

      expect(result, Result.success(topArticles));
      verify(articlesRepository.topHeadlines());
      verifyNoMoreInteractions(articlesRepository);
    },
  );
}
