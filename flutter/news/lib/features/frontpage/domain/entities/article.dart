import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:news/features/frontpage/domain/entities/source.dart';

part 'article.freezed.dart';
part 'article.g.dart';

@freezed
class Article with _$Article {
  const factory Article(
      {required Source source,
      required String author,
      required String title,
      required String description,
      required String url,
      required String urlToImage,
      required String publishedAt,
      required String content}) = _Article;

  factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
}
