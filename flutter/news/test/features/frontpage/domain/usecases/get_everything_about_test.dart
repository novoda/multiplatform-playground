import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';
import 'package:news/features/frontpage/domain/usecases/get_everything_about.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';

import 'get_top_headlines_test.mocks.dart';

@GenerateMocks([ArticlesRepository])
void main() {
  late GetEverythingAbout usecase;
  late MockArticlesRepository mockArticlesRepository;
  late List<Article> tArticlesList;
  late String tQuery;

  setUp(() {
    mockArticlesRepository = MockArticlesRepository();
    usecase = GetEverythingAbout(mockArticlesRepository);
    tArticlesList = [Article(
        source: Source(id: "id", name: "name"),
        author: "author",
        title: "title",
        description: "description",
        url: "url",
        urlToImage: "urlToImage",
        publishedAt: "publishedAt",
        content: "content")];
    tQuery = "war";
  });



  test(
    'should get list articles about X from repository ',
        () async {
      when(mockArticlesRepository.getEverythingAbout(tQuery))
          .thenAnswer((_) async => Right(tArticlesList));

      final result = await usecase(Params(query: tQuery));

      expect(result, Right(tArticlesList));
      verify(mockArticlesRepository.getEverythingAbout(tQuery));
      verifyNoMoreInteractions(mockArticlesRepository);
    },
  );
}
