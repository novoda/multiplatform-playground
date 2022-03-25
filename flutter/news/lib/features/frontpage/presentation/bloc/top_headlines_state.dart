import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/features/frontpage/presentation/bloc/top_headlines_viewstate.dart';

part 'top_headlines_state.freezed.dart';

@freezed
class ArticlesState with _$ArticlesState {
  const factory ArticlesState.initial() = _Initial;
  const factory ArticlesState.loading() = _Loading;
  const factory ArticlesState.loaded({
    required List<TopHeadlineViewState> viewState,
  }) = Loaded;
  const factory ArticlesState.error() = _Error;
}
