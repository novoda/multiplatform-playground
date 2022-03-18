import 'package:equatable/equatable.dart';
import 'package:news/features/frontpage/domain/entities/article.dart';
import 'package:json_annotation/json_annotation.dart';
part 'base_news_response.g.dart';

@JsonSerializable()
class BaseNewsResponse extends Equatable {
  final String status;
  final int totalResults;
  final List<Article> articles;

  const BaseNewsResponse(
      {required this.status,
      required this.totalResults,
      required this.articles});

  factory BaseNewsResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseNewsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BaseNewsResponseToJson(this);

  @override
  List<Object> get props => [status, totalResults, articles];
}
