import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';

part 'base_news_response.freezed.dart';
part 'base_news_response.g.dart';

@freezed
class BaseNewsResponse with _$BaseNewsResponse {
  const factory BaseNewsResponse({
    required String status,
    required int totalResults,
    required List<Article> articles,
  }) = _BaseNewsResponse;

  factory BaseNewsResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseNewsResponseFromJson(json);
}
