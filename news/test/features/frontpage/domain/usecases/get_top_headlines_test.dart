import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/usecases/usecase.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';
import 'package:news/features/frontpage/domain/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';

import 'get_top_headlines_test.mocks.dart';

@GenerateMocks([ArticlesRepository])
void main() {
  late GetTopHeadlines usecase;
  late MockArticlesRepository mockArticlesRepository;
  late List<Article> tArticlesList;

  setUp(() {
    mockArticlesRepository = MockArticlesRepository();
    usecase = GetTopHeadlines(mockArticlesRepository);
    tArticlesList = [Article(
        source: Source(id: "id", name: "name"),
        author: "author",
        title: "title",
        description: "description",
        url: "url",
        urlToImage: "urlToImage",
        publishedAt: "publishedAt",
        content: "content")];
  });



  test(
    'should get list of top headlines from repository ',
    () async {
      // arrange
      when(mockArticlesRepository.getTopHeadlines())
          .thenAnswer((_) async => Right(tArticlesList));
      // act
      final result = await usecase(NoParams());
      //assert
      expect(result, Right(tArticlesList));
      verify(mockArticlesRepository.getTopHeadlines());
      verifyNoMoreInteractions(mockArticlesRepository);
    },
  );
}
