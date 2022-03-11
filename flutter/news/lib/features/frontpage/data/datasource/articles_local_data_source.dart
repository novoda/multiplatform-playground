import 'package:news/core/result.dart';
import 'package:news/features/frontpage/data/models/article_model.dart';

abstract class ArticlesLocalDataSource {
  Future<Result<List<ArticleModel>>> getLastTopHeadlines();
  Future<void> cacheTopHeadlines(List<ArticleModel> topHeadlinesList);
}
