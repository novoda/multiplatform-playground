import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

part 'top_headlines_viewstate.freezed.dart';

@freezed
class TopHeadlineViewState with _$TopHeadlineViewState {
  const factory TopHeadlineViewState({
    required String title,
    required String url,
    required String? imageUrl,
  }) = _TopHeadLineViewState;

  factory TopHeadlineViewState.from({required Article article}) =>
      _TopHeadLineViewState(
        title: article.title,
        url: article.url,
        imageUrl: article.urlToImage,
      );
}
