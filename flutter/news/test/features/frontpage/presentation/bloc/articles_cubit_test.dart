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
  final articles = List.generate(15, (index) => Stub.article(title: "$index"));
  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN sync will succeed '
    'WHEN syncing is triggered '
    'THEN emits [Loading]',
    build: () {
      when(useCase.sync()).thenAnswer(
        (_) async => Result.completed(),
      );
      return ArticlesCubit(useCase: useCase);
    },
    act: (cubit) => cubit.sync(),
    expect: () => <ArticlesState>[
      const ArticlesState.loading(),
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN syncing will fail '
    'WHEN syncing is triggered '
    'THEN emits [Loading, Error]',
    build: () {
      when(useCase.sync()).thenAnswer(
        (_) async => const CacheFailure(message: "No headlines saved")
            .asFailure<List<Article>>(),
      );
      return ArticlesCubit(useCase: useCase);
    },
    act: (cubit) => cubit.sync(),
    expect: () => <ArticlesState>[
      const ArticlesState.loading(),
      const ArticlesState.error(error: 'No headlines saved')
    ],
  );

  blocTest<ArticlesCubit, ArticlesState>(
    'GIVEN will return articles '
    'WHEN response is successful '
    'THEN emits Loaded with data limited to 10 items',
    build: () {
      when(useCase.topHeadlines()).thenAnswer(
        (_) => Stream.value(articles),
      );
      return ArticlesCubit(useCase: useCase);
    },
    act: (cubit) => cubit.init(),
    expect: () => <ArticlesState>[
      ArticlesState.loaded(
        viewState: articles
            .getRange(0, 10)
            .map((article) => TopHeadlineViewState.from(article: article))
            .toList(),
      )
    ],
  );
}
