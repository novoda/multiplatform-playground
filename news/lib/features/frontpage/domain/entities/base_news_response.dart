import 'package:news/features/frontpage/domain/entities/article.dart';

class BaseNewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  BaseNewsResponse(
      {required this.status,
      required this.totalResults,
      required this.articles});
}
