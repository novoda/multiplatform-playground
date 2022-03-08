import 'package:collection/collection.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';
import 'package:news/features/frontpage/domain/entities/base_news_response.dart';

class BaseNewsResponseModel extends BaseNewsResponse {
  BaseNewsResponseModel(
      {required String status,
      required int totalResults,
      required List<ArticleModel> articles})
      : super(status: status, totalResults: totalResults, articles: articles);

  factory BaseNewsResponseModel.fromJson(Map<String, dynamic> json) {
    var articlesL = <ArticleModel>[];
    if (json['articles'] != null) {
      json['articles'].forEach((v) {
        articlesL.add(ArticleModel.fromJson(v));
      });
    }

    return BaseNewsResponseModel(
        status: json['status'],
        totalResults: json["totalResults"],
        articles: articlesL);
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "totalResults": totalResults,
      "articles": (articles).map((e) => (e as ArticleModel).toJson()).toList()
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseNewsResponseModel &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          totalResults == other.totalResults &&
          const DeepCollectionEquality().equals(articles, other.articles);

  @override
  int get hashCode =>
      status.hashCode ^ totalResults.hashCode ^ articles.hashCode;

  @override
  String toString() {
    return 'BaseNewsResponseModel{status: $status, totalResults: $totalResults, articles: $articles}';
  }
}
