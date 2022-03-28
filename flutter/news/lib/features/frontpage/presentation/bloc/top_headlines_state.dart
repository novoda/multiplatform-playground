import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/core/error/failures.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

part 'top_headlines_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState.initial() = _Initial;
  const factory ArticlesState.loading() = _Loading;
  const factory ArticlesState.loaded({
    required List<TopHeadlineViewState> viewState,
  }) = _Loaded;
  const factory ArticlesState.error() = _Error;

  factory ArticlesState.from(
    List<Article> articles,
    bool isLoading,
    InternalFailure? failure,
  ) {
    if (isLoading) {
      return const ArticlesState.loading();
    } else if (failure != null) {
      return const ArticlesState.error();
    } else {
      return ArticlesState.loaded(
        viewState: articles
            .map((e) => TopHeadlineViewState.from(article: e))
            .take(10)
            .toList(),
      );
    }
  }
}
