import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';

import '../../domain/usecases/get_everything_about_test.mocks.dart';


@GenerateMocks([ArticlesRepository])
void main() {
  late ArticlesRepository repository;
  late List<Article> topHeadlines;

  setUp(() {
    repository = MockArticlesRepository();
    topHeadlines = [
      const Article(
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

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN topHeadlines is requested WHEN response is successful '
    'THEN emits [TopHeadlinesLoading, TopHeadlinesLoaded]',
    build: () => ArticlesCubit(repository: repository),
    act: (cubit) {
      when(repository.topHeadlines())
          .thenAnswer((_) async => Result.success(topHeadlines));
      cubit.getTopHeadlines();
    },
    expect: () => <ArticlesState>[
      TopHeadlinesLoading(),
      TopHeadlinesLoaded(topHeadlines)
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN topHeadlines is requested WHEN response is failure '
        'THEN emits [TopHeadlinesLoading, TopHeadlinesError]',
    build: () => ArticlesCubit(repository: repository),
    act: (cubit) {
      when(repository.topHeadlines())
          .thenAnswer((_) async => Result.failure(const CacheFailure("No headlines saved")));
      cubit.getTopHeadlines();
    },
    expect: () => <ArticlesState>[
      TopHeadlinesLoading(),
      TopHeadlinesError()
    ],
  );
}
