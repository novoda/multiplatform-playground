import 'package:freezed_annotation/freezed_annotation.dart';

part 'top_headlines_viewstate.freezed.dart';

@freezed
class TopHeadlineViewState with _$TopHeadlineViewState {
  const factory TopHeadlineViewState({
    required String title,
    required String url,
    required String imageUrl,
  }) = _TopHeadLineViewState;
}
