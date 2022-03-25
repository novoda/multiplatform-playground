import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/usecases/get_everything_about_test.mocks.dart';

@GenerateMocks([ArticlesRepository])
void main() {
  final ArticlesRepository repository = MockArticlesRepository();

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN topHeadlines is requested '
    'WHEN response is successful '
    'THEN emits [TopHeadlinesLoading, TopHeadlinesLoaded]',
    build: () {
      when(repository.topHeadlines()).thenAnswer(
        (_) async => Result.success(
            [Stub.article(title: "title", url: "url", imageUrl: "image")]),
      );
      return ArticlesCubit(repository: repository);
    },
    act: (cubit) => cubit.getTopHeadlines(),
    expect: () => <ArticlesState>[
      TopHeadlinesLoading(),
      const TopHeadlinesLoaded([TopHeadlineViewState("title", "url", "image")])
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
      'GIVEN topHeadlines is requested '
      'WHEN response is failure '
      'THEN emits [TopHeadlinesLoading, TopHeadlinesError]',
      build: () {
        when(repository.topHeadlines()).thenAnswer((_) async => Result.failure(
              const CacheFailure("No headlines saved"),
            ));
        return ArticlesCubit(repository: repository);
      },
      act: (cubit) => cubit.getTopHeadlines(),
      expect: () => [isA<TopHeadlinesLoading>(), isA<TopHeadlinesError>()]);

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN topHeadlines is requested '
    'WHEN response is successful '
    'THEN verify TopHeadlineViewState is limited to the first 10 elements',
    build: () {
      when(repository.topHeadlines()).thenAnswer((_) async => Result.success(
            List.generate(15, (index) => Stub.article(title: "$index")),
          ));
      return ArticlesCubit(repository: repository);
    },
    act: (cubit) => cubit.getTopHeadlines(),
    verify: (cubit) {
      final cubitState = cubit.state as TopHeadlinesLoaded;
      expect(cubitState.topHeadlines.length, 10);
      expect(cubitState.topHeadlines.first.title, "0");
      expect(cubitState.topHeadlines.last.title, "9");
    },
  );
}
