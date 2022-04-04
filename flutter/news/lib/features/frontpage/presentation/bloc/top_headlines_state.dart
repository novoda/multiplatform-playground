import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/presentation/bloc/articles_cubit.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

part 'top_headlines_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState.initial() = _Initial;

  const factory ArticlesState.loading() = _Loading;

  const factory ArticlesState.loaded({
    required List<TopHeadlineViewState> viewState,
  }) = _Loaded;
  const factory ArticlesState.error({required String message}) = _Error;

  factory ArticlesState.from(
    List<Article> articles,
    CommandStatus status,
  ) =>
      status.when(
        loading: () => const ArticlesState.loading(),
        idle: () => ArticlesState.loaded(
          viewState: articles
              .map((e) => TopHeadlineViewState.from(article: e))
              .take(10)
              .toList(),
        ),
        error: (message) => ArticlesState.error(message: message),
      );
}
