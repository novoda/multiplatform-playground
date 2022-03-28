import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/core/result.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/domain/usecases/get_top_headlines.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_state.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

import '../../../../core/utils/extensions.dart';
import 'articles_cubit_test.mocks.dart';

@GenerateMocks([GetTopHeadlines])
void main() {
  final GetTopHeadlines useCase = MockGetTopHeadlines();
  final oldArticles =
      List.generate(15, (index) => Stub.article(title: "old $index"));
  final newArticles =
      List.generate(15, (index) => Stub.article(title: "new $index"));
  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN old data is present AND sync will succeed AND new data is retrieved'
    'WHEN syncing is triggered '
    'THEN emits [Loaded (old), Loading, Loaded (new)]',
    setUp: () {
      var controller = StreamController<List<Article>>()..add(oldArticles);
      when(useCase.topHeadlines()).thenAnswer(
        (_) => controller.stream,
      );
      when(useCase.sync()).thenAnswer(
        (_) => Future.value(Result.completed())
            .whenComplete(() => controller.add(newArticles)),
      );
    },
    build: () => ArticlesCubit(useCase),
    act: (cubit) => cubit
      ..init()
      ..sync(),
    expect: () => <ArticlesState>[
      ArticlesState.loaded(
        viewState: oldArticles
            .getRange(0, 10)
            .map((article) => TopHeadlineViewState.from(article: article))
            .toList(),
      ),
      const ArticlesState.loading(),
      ArticlesState.loaded(
        viewState: newArticles
            .getRange(0, 10)
            .map((article) => TopHeadlineViewState.from(article: article))
            .toList(),
      )
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN old data is present AND sync will fail'
    'WHEN syncing is triggered '
    'THEN emits [Loaded (old), Loading, Error]',
    setUp: () {
      var controller = StreamController<List<Article>>()..add(oldArticles);
      when(useCase.topHeadlines()).thenAnswer(
        (_) => controller.stream,
      );
      when(useCase.sync()).thenAnswer(
        (_) async => const ServerFailure(message: "Unable to read API")
            .asFailure<void>(),
      );
    },
    build: () => ArticlesCubit(useCase),
    act: (cubit) => cubit
      ..init()
      ..sync(),
    expect: () => <ArticlesState>[
      ArticlesState.loaded(
        viewState: oldArticles
            .getRange(0, 10)
            .map((article) => TopHeadlineViewState.from(article: article))
            .toList(),
      ),
      const ArticlesState.loading(),
      const ArticlesState.error()
    ],
  );
}
