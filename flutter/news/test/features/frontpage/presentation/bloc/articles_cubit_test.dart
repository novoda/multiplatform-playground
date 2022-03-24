import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/repositories/articles_repository.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/usecases/get_everything_about_test.mocks.dart';

@GenerateMocks([ArticlesRepository])
void main() {
  final ArticlesRepository repository = MockArticlesRepository();

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN topHeadlines is requested '
    'WHEN response is successful '
    'THEN emits [Loading, Loaded]',
    build: () {
      when(repository.topHeadlines()).thenAnswer(
        (_) async => [
          Stub.article(title: "title", url: "url", imageUrl: "image")
        ].asSuccess(),
      );
      return ArticlesCubit(repository: repository);
    },
    act: (cubit) => cubit.getTopHeadlines(),
    expect: () => <ArticlesState>[
      const ArticlesState.loading(),
      const ArticlesState.loaded(viewState: [
        TopHeadlineViewState(
          title: "title",
          url: "url",
          imageUrl: "image",
        )
      ])
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN topHeadlines is requested '
    'WHEN response is failure '
    'THEN emits [Loading, Error]',
    build: () {
      when(repository.topHeadlines()).thenAnswer(
        (_) async => const CacheFailure(message: "No headlines saved")
            .asFailure<List<Article>>(),
      );
      return ArticlesCubit(repository: repository);
    },
    act: (cubit) => cubit.getTopHeadlines(),
    expect: () => <ArticlesState>[
      const ArticlesState.loading(),
      const ArticlesState.error(),
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN topHeadlines is requested '
    'WHEN response is successful '
    'THEN verify View State is limited to the first 10 elements',
    build: () {
      when(repository.topHeadlines()).thenAnswer((_) async =>
          List.generate(15, (index) => Stub.article(title: "$index"))
              .asSuccess());
      return ArticlesCubit(repository: repository);
    },
    act: (cubit) => cubit.getTopHeadlines(),
    verify: (cubit) {
      final cubitState = cubit.state as Loaded;
      expect(cubitState.viewState.length, 10);
      expect(cubitState.viewState.first.title, "0");
      expect(cubitState.viewState.last.title, "9");
    },
  );
}
